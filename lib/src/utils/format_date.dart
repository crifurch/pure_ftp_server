const _month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec',
];

String _formatTime(int value) => value < 10 ? '0$value' : value.toString();

String formatListDate(DateTime dateTime) => ''
    '${_month[dateTime.month - 1]} '
    '${dateTime.day} '
    '${dateTime.year == DateTime.now().year ? '${_formatTime(dateTime.hour)}:${_formatTime(dateTime.minute)}' : dateTime.year}';
