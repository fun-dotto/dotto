# TimetableRepository

時間割データの取得・管理を行うリポジトリクラス

## 概要

`TimetableRepository` は、以下の責務を持つシングルトンクラスです：

- 個人時間割データのローカル保存・読み込み
- Firestoreとの同期処理
- 2週間分のスケジュール生成
- 休講・補講情報の統合
- 時間割重複チェック

## メソッド分類

### 1. データ取得系（プライベート）

#### `_getPersonalTimetableList()`
SharedPreferencesから時間割IDリストを取得する基盤メソッド。
多くの他のメソッドから呼び出される中心的な役割を持つ。

**呼び出し元:**
- `loadPersonalTimetableListOnLogin()`
- `loadPersonalTimetableList()`
- `filterTimetable()`
- `loadPersonalTimetableMapString()`
- `isOverSeleted()`

---

### 2. 同期・ロード系（パブリック）

#### `loadPersonalTimetableListOnLogin(BuildContext context, WidgetRef ref)`
ログイン時の同期処理。FirestoreとローカルのデータをUIダイアログで確認しながら同期。

**依存関係:**
```
loadPersonalTimetableListOnLogin()
  ├─ _getPersonalTimetableList()
  ├─ CourseDB.getLessonNameList()
  └─ savePersonalTimetableListToFirestore()
```

**処理フロー:**
1. Firestoreからユーザーデータ取得
2. ローカルデータとの差分を計算
3. 差分が大きい場合、ユーザーに選択を促す
4. 選択されたデータを同期

#### `loadPersonalTimetableList(WidgetRef ref)`
通常時のロード処理。Firestoreとローカルを自動同期。

**依存関係:**
```
loadPersonalTimetableList()
  ├─ _getPersonalTimetableList()
  ├─ savePersonalTimetableListToFirestore()
  └─ savePersonalTimetableList()
```

**戻り値:** `Future<List<int>>` - 時間割IDリスト

---

### 3. Firestore操作系（パブリック）

#### `addPersonalTimetableListToFirestore(int lessonId, WidgetRef ref)`
Firestoreに単一授業を追加。

**処理内容:**
- `FieldValue.arrayUnion()` でIDを追加
- `last_updated` をサーバータイムスタンプで更新

#### `removePersonalTimetableListFromFirestore(int lessonId, WidgetRef ref)`
Firestoreから単一授業を削除。

**処理内容:**
- `FieldValue.arrayRemove()` でIDを削除
- `last_updated` をサーバータイムスタンプで更新

#### `savePersonalTimetableListToFirestore(List<int> personalTimetableList, WidgetRef ref)`
Firestoreにリスト全体を保存（上書き）。

**処理内容:**
- `doc.set()` でリスト全体を保存
- `last_updated` をサーバータイムスタンプで更新

---

### 4. ローカル状態管理系（パブリック）

#### `savePersonalTimetableList(List<int> personalTimetableList, WidgetRef ref)`
Riverpodプロバイダー（`personalLessonIdListProvider`）に時間割リストを保存。

#### `addPersonalTimetableList(int lessonId, WidgetRef ref)`
授業を追加する高レベルメソッド（ローカル + Firestore）。

**依存関係:**
```
addPersonalTimetableList()
  ├─ personalLessonIdListProvider.notifier.add()
  └─ addPersonalTimetableListToFirestore()
```

#### `removePersonalTimetableList(int lessonId, WidgetRef ref)`
授業を削除する高レベルメソッド（ローカル + Firestore）。

**依存関係:**
```
removePersonalTimetableList()
  ├─ personalLessonIdListProvider.notifier.remove()
  └─ removePersonalTimetableListFromFirestore()
```

---

### 5. スケジュール取得系（パブリック）

#### `getDateRange()`
月曜から次の週の日曜までの14日分の日付を生成。

**戻り値:** `List<DateTime>` - 14日分の日付リスト

#### `get2WeekLessonSchedule()`
2週間分のスケジュールを生成。

**依存関係:**
```
get2WeekLessonSchedule()
  ├─ getDateRange()
  └─ dailyLessonSchedule() (各日付に対して)
```

**戻り値:** `Future<Map<DateTime, Map<int, List<TimetableCourse>>>>`
- キー: 日付
- 値: 時限ごとの授業リスト

#### `dailyLessonSchedule(DateTime selectTime)`
指定日の授業スケジュールを生成。休講・補講情報も統合。

**依存関係:**
```
dailyLessonSchedule()
  ├─ filterTimetable()
  │   └─ _getPersonalTimetableList()
  ├─ loadPersonalTimetableMapString()
  │   └─ _getPersonalTimetableList()
  └─ readJsonFile() (cancel_lecture.json, sup_lecture.json)
```

**戻り値:** `Future<Map<int, List<TimetableCourse>>>`
- キー: 時限（1〜6）
- 値: その時限の授業リスト

---

### 6. フィルタ・マッピング系（パブリック）

#### `filterTimetable()`
JSONファイル（`oneweek_schedule.json`）から履修中の科目のみをフィルタ。

**依存関係:**
```
filterTimetable()
  └─ _getPersonalTimetableList()
```

**戻り値:** `Future<List<dynamic>>` - フィルタされた授業データ

#### `loadPersonalTimetableMapString()`
授業名 → 授業IDのマップを生成（SQLiteから取得）。

**依存関係:**
```
loadPersonalTimetableMapString()
  └─ _getPersonalTimetableList()
```

**戻り値:** `Future<Map<String, int>>`
- キー: 授業名
- 値: 授業ID

---

### 7. 検証系（パブリック）

#### `fetchRecords()`
`week_period` テーブルから全レコードを取得。

**戻り値:** `Future<List<Map<String, dynamic>>>` - 全レコード

#### `isOverSeleted(int lessonId, WidgetRef ref)`
指定した授業を追加した際に、時間割が重複するかチェック。
重複が検出された場合、古い授業を自動削除。

**依存関係:**
```
isOverSeleted()
  ├─ _getPersonalTimetableList()
  ├─ weekPeriodAllRecordsProvider.watch()
  └─ savePersonalTimetableList() (重複解消時)
```

**戻り値:** `Future<bool>` - 重複が発生した場合 `true`

---

## 主要な依存フロー

### ユーザー操作時（追加・削除）

```
ユーザー操作（追加/削除）
    ↓
addPersonalTimetableList / removePersonalTimetableList
    ↓
├─ personalLessonIdListProvider（Riverpod状態更新）
└─ addPersonalTimetableListToFirestore / removePersonalTimetableListFromFirestore
    ↓
Firebase同期完了
```

### 画面表示時（スケジュール取得）

```
画面表示
    ↓
get2WeekLessonSchedule
    ↓
getDateRange → dailyLessonSchedule（各日付）
    ↓
├─ filterTimetable → _getPersonalTimetableList
└─ loadPersonalTimetableMapString → _getPersonalTimetableList
    ↓
TimetableCourseリスト返却
```

### ログイン時（同期）

```
ログイン
    ↓
loadPersonalTimetableListOnLogin
    ↓
├─ Firestoreから取得
├─ ローカルから取得（_getPersonalTimetableList）
├─ 差分計算
└─ ユーザー確認 or 自動同期
    ↓
savePersonalTimetableListToFirestore
```

---

## 特徴・設計ポイント

1. **シングルトンパターン**
   - `TimetableRepository._instance` でアプリ全体で1つのインスタンスを共有

2. **中心的なプライベートメソッド**
   - `_getPersonalTimetableList()` が多くのメソッドから呼ばれる基盤

3. **Firestore同期とローカル状態管理の分離**
   - Firestore操作系メソッドとローカル状態管理系メソッドが明確に分離
   - 高レベルメソッド（`addPersonalTimetableList` など）が両方を組み合わせて使用

4. **データソースの多様性**
   - SharedPreferences（ローカルキャッシュ）
   - Firestore（ユーザーデータ同期）
   - SQLite（シラバスデータ）
   - JSONファイル（施設予約、休講・補講情報）

5. **同期戦略**
   - タイムスタンプベースで差分を判定（5分・10分の閾値）
   - 差分が大きい場合はユーザーに選択を促す

---

## 関連ファイル

- `lib/feature/timetable/controller/personal_lesson_id_list_controller.dart` - 時間割IDリストの状態管理
- `lib/feature/timetable/controller/week_period_all_records_controller.dart` - 週・時限の全レコード管理
- `lib/data/db/course_db.dart` - コース（授業）データベース操作
- `lib/feature/timetable/domain/timetable_course.dart` - 時間割授業のドメインモデル

---

## 注意事項

- **非推奨パターン**: `_getPersonalTimetableList()` → SQLiteクエリ のパターンは、CourseDBを経由する方が望ましい
- **コメントアウトされたエラーハンドリング**: 229-231行、247-249行のエラーハンドリングが無効化されている
- **ハードコードされた年度**: `'2025'` が複数箇所にハードコードされている（将来的に動的取得が望ましい）
- **188行目のコメント**: "ここなぜか取得できない" - 調査が必要な可能性
