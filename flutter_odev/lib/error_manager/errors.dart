
class ErrorManager {
  static String show(String errCode) {
    switch (errCode) {
      case 'invalid-email':
        return "Geçersiz mail";
      case 'emaıl-already-ın-use':
        return 'Bu mail zaten kullanımda';
      case 'wrong-password':
        return 'Hatalı kullanıcı adı veya şifre';
      case 'user-not-found':
        return 'Böyle bir kullanıcı bulunamadı';
      case 'operation-not-allowed':
        return 'Erişim kısıtı';
      case 'weak-password':
        return 'Zayıf şifre';
      case 'user-not-verified':
        return 'Kullanıcı onaylanmadı';
      case 'network-request-failed':
        return 'İnternetinizde sorun yaşıyoruz';
      default:
        return 'Beklenmeyen bir hata oluştu';
    }
  }
}
