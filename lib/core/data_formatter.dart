import 'package:intl/intl.dart';

class DateFormatter {
  static String timeAgo(String? dateString) {
    if (dateString == null) return '';
    
    try {
      DateTime publishedAt = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(publishedAt);

      if (difference.inDays > 7) {
        return DateFormat('dd/MM/yyyy').format(publishedAt);
      } else if (difference.inDays >= 1) {
        return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
      } else if (difference.inHours >= 1) {
        return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes >= 1) {
        return 'Hace ${difference.inMinutes} min';
      } else {
        return 'Recién publicado';
      }
    } catch (e) {
      return '';
    }
  }
}