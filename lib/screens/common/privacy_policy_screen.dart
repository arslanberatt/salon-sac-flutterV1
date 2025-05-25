import 'package:flutter/material.dart';
import 'package:mobil/utils/constants/sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(249, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Gizlilik ve Kullanım Koşullar",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Teko',
            color: Colors.black87,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "Kişisel Verilerin Korunması",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Domine'),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Uygulamamız, kullanıcıların kişisel bilgilerini gizli tutar ve üçüncü taraflarla paylaşmaz. E-posta, telefon gibi bilgiler yalnızca hizmet sunumu amacıyla kullanılır.",
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Kullanım Koşulları",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Domine'),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Bu uygulamayı kullanarak sağlanan bilgilerin doğru olduğunu taahhüt etmiş olursunuz. Uygulama içeriğini kopyalamak, çoğaltmak veya izinsiz paylaşmak yasaktır.",
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Hizmet Değişikliği",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Domine'),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Uygulama sahibi, haber vermeksizin hizmetlerde değişiklik yapma veya sonlandırma hakkını saklı tutar.",
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Sorumluluk Reddi",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Domine'),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Kullanıcı kaynaklı veri kayıplarından ya da hatalı kullanımdan doğabilecek sorunlardan geliştirici sorumlu değildir.",
                ),
              ),
              SizedBox(height: 16),
              Text(
                "İletişim",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Domine'),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Her türlü soru ve destek talepleriniz için arslanberattdev@gmail.com adresinden bizimle iletişime geçebilirsiniz.",
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  "© 2025 Salon Saç. Tüm hakları saklıdır.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
