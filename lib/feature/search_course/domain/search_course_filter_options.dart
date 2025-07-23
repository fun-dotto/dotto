import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';

enum SearchCourseFilterOptions {
  largeCategory(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '0',
        label: '専門',
      ),
      SearchCourseFilterOptionChoice(
        id: '1',
        label: '教養',
      ),
      SearchCourseFilterOptionChoice(
        id: '2',
        label: '大学院',
      ),
    ],
  ),
  term(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '10',
        label: '前期',
      ),
      SearchCourseFilterOptionChoice(
        id: '20',
        label: '後期',
      ),
      SearchCourseFilterOptionChoice(
        id: '0',
        label: '通年',
      ),
    ],
  ),
  grade(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '一年次',
        label: '1年',
      ),
      SearchCourseFilterOptionChoice(
        id: '二年次',
        label: '2年',
      ),
      SearchCourseFilterOptionChoice(
        id: '三年次',
        label: '3年',
      ),
      SearchCourseFilterOptionChoice(
        id: '四年次',
        label: '4年',
      ),
    ],
  ),
  course(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '情報システムコース',
        label: '情シス',
      ),
      SearchCourseFilterOptionChoice(
        id: '情報デザインコース',
        label: '情デザ',
      ),
      SearchCourseFilterOptionChoice(
        id: '複雑コース',
        label: '複雑',
      ),
      SearchCourseFilterOptionChoice(
        id: '知能システムコース',
        label: '知能',
      ),
      SearchCourseFilterOptionChoice(
        id: '高度ICTコース',
        label: '高度ICT',
      ),
    ],
  ),
  classification(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '100',
        label: '必修',
      ),
      SearchCourseFilterOptionChoice(
        id: '101',
        label: '選択',
      ),
    ],
  ),
  educationField(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '2',
        label: '社会',
      ),
      SearchCourseFilterOptionChoice(
        id: '1',
        label: '人間',
      ),
      SearchCourseFilterOptionChoice(
        id: '3',
        label: '科学',
      ),
      SearchCourseFilterOptionChoice(
        id: '4',
        label: '健康',
      ),
      SearchCourseFilterOptionChoice(
        id: '5',
        label: 'コミュ',
      ),
    ],
  ),
  masterField(
    choices: [
      SearchCourseFilterOptionChoice(
        id: '全領域',
        label: '全領域',
      ),
      SearchCourseFilterOptionChoice(
        id: '情報ア',
        label: '情報ア',
      ),
      SearchCourseFilterOptionChoice(
        id: '高度ICT',
        label: '高度ICT',
      ),
      SearchCourseFilterOptionChoice(
        id: 'デザ',
        label: 'デザ',
      ),
      SearchCourseFilterOptionChoice(
        id: '複雑',
        label: '複雑',
      ),
      SearchCourseFilterOptionChoice(
        id: '知能',
        label: '知能',
      ),
    ],
  );

  const SearchCourseFilterOptions({
    required this.choices,
  });

  final List<SearchCourseFilterOptionChoice> choices;

  List<String> get ids => choices.map((e) => e.id).toList();
  List<String> get labels => choices.map((e) => e.label).toList();
}
