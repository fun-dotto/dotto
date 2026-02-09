final class QuickLink {
  const QuickLink({required this.label, required this.url, required this.icon});

  final String label;
  final String url;
  final String icon;

  static const List<QuickLink> links = [
    QuickLink(
      label: 'HOPE',
      url: 'https://hope.fun.ac.jp/auth/saml2/login.php?idp=1bec319bca7458548c77d545a2a1b3de',
      icon: 'https://hope.fun.ac.jp/pluginfile.php/1/core_admin/favicon/64x64/1756948564/favicon.ico',
    ),
    QuickLink(
      label: '学生ポータル',
      url: 'https://students.fun.ac.jp/Portal',
      icon: 'https://students.fun.ac.jp/favicon.ico',
    ),
  ];
}
