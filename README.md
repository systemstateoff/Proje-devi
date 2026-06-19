🏗️ Hibrit Bulut Mimarisi (AWS & GCP)


Proje, AWS ve GCP üzerinde eş zamanlı olarak yapılandırılmış, yüksek erişilebilirliğe ve güvenliğe sahip hibrit bir altyapıdan oluşmaktadır.

1. AWS Altyapısı (High Availability)
Ağ Katmanı: 10.2.0.0/16 CIDR bloğunda, Multi-AZ destekli VPC.

Subnet Yapısı: 2 Public (ALB için) ve 2 Private (EC2 için) subnet ile ağ segmentasyonu.

Servis Katmanı:

ALB: Gelen trafiği yönetir ve trafiği private subnet'lerdeki örneklere dağıtır.

Auto Scaling Group (ASG): İki farklı AZ üzerinde çalışarak yüksek erişilebilirlik sağlar, "Hello AWS" servisini yüksek trafik altında ayakta tutar.

2. GCP Altyapısı (Secure Access)
Ağ Katmanı: Custom VPC ve özelleştirilmiş subnet.

Servis Katmanı: Öneri motorunu barındıran Compute Engine (VM).

Güvenlik: Harici erişime tamamen kapalıdır. Sadece Google Cloud'un IAP (Identity-Aware Proxy) servisi üzerinden, kimlik doğrulaması yapılmış erişimlere izin verilmiştir.

🔐 Altyapı Güvenliği ve State Yönetimi
Altyapı kurulumunda, operasyonel güvenliği ve ekip çalışması sürekliliğini sağlamak adına endüstri standardı olan Terraform State Locking yöntemi kullanılmıştır:
S3 Backend: Terraform state (.tfstate) dosyaları, güvenli ve şifreli bir AWS S3 bucket'ı içerisinde depolanır.

DynamoDB Locking: Merkezi bir DynamoDB tablosu, "State Locking" mekanizmasıyla çalışır. Bu yapı, aynı anda birden fazla Terraform işleminin çakışmasını engeller ve altyapı durum (state) dosyasının bütünlüğünü koruyarak veri kaybını önler.

💡 Karşılaşılan Zorluklar ve Çözüm Yaklaşımları

Bu proje süreci boyunca altyapı yönetimi ve Terraform ile ilk kez çalışmanın getirdiği birtakım zorluklarla karşılaştım. Bu süreç, teorik bilgiyi pratik bir mühendislik disipliniyle birleştirme noktasında önemli bir öğrenme deneyimi oldu.

Öğrenme Eğrisi ve Terraform Adaptasyonu: Terraform'un deklaratif yapısı ve modüler mimarisiyle ilk kez çalışmak başlangıçta zorlayıcıydı. Bu süreci, kapsamlı teknik dökümanları inceleyerek ve yapay zeka destekli kod geliştirme araçlarından faydalanarak aştım. Bu yöntem, Terraform ile altyapı yönetimi konusundaki yetkinliğimi artırırken, bulut tarafında farklı servislerin birbiriyle entegre çalıştığı karmaşık mimari altyapıları kurgulama konusunda ciddi bir deneyim kazandırdı.

Hata Ayıklama ve Süreç İyileştirme: Kod geliştirme aşamasında oluşan hatalar, altyapının planlanması ve uygulanması sırasında çeşitli pürüzler yarattı. Bu problemleri çözmek için:

Terraform'un hata mesajlarını analiz ederek kodun mantıksal yapısını gözden geçirdim.

Hatalı kısımları izole ederek, çözüm önerilerini yapay zeka ile valide ettim ve kod bloğunu yinelemeli (iterative) bir yaklaşımla optimize ettim.

Bu deneyim, bana sadece altyapı kurulumunu değil, aynı zamanda hata yönetimi ve sürekli iyileştirme (continuous improvement) kültürünü kazandırarak, hibrit bulut mimarilerini uçtan uca yönetebilir bir yetkinliğe ulaşmamı sağladı.
