var monthsNames = [
  "Jan",
  "Feb",
  "März",
  "Apr",
  "Mai",
  "Juni",
  "Juli",
  "Aug",
  "Sept",
  "Okt",
  "Nov",
  "Dez"
];

String getFormattedDate(int dueToDate) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(dueToDate);
  return "${date.day}  ${monthsNames[date.month -1]}";
}
