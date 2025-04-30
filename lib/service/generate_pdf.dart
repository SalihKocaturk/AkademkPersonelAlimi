import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateFullTablo5Pdf() async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load("fonts/DejaVuSans.ttf");
  final ttf = pw.Font.ttf(fontData);
  final articleDescriptions = [
    '1) SCI-E, SSCI veya AHCI kapsamındaki dergilerde yayımlanmış makale (Q1 olarak taranan dergide)',
    '2) SCI-E, SSCI veya AHCI kapsamındaki dergilerde yayımlanmış makale (Q2 olarak taranan dergide)',
    '3) SCI-E, SSCI veya AHCI kapsamındaki dergilerde yayımlanmış makale (Q3 olarak taranan dergide)',
    '4) SCI-E, SSCI veya AHCI kapsamındaki dergilerde yayımlanmış makale (Q4 olarak taranan dergide)',
    '5) ESCI tarafından taranan dergilerde yayımlanmış makale',
    '6) Scopus tarafından taranan dergilerde yayımlanmış makale',
    '7) Uluslararası diğer indekslerde taranan dergilerde yayımlanmış makale',
    '8) ULAKBİM TR Dizin tarafından taranan ulusal hakemli dergilerde yayımlanmış makale',
    '9) 8. madde dışındaki ulusal hakemli dergilerde yayımlanmış makale',
  ];
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttf,
        italic: ttf,
        boldItalic: ttf,
      ),
      build:
          (context) => [
            // ÜST BİLGİ ALANLARI (Tablo halinde)
            // ÜST BİLGİ TABLOSU
            // GENEL PUANLAMA BİLGİLERİ
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        'GENEL PUANLAMA BİLGİLERİ',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Container(), // boş hücre
                  ],
                ),
              ],
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.35),
                1: pw.FractionColumnWidth(0.65),
              },
              children: [
                _row('Adı Soyadı (Unvanı):', ''),
                _row('Tarih:', ''),
                _row('Bulunduğu Kurum:', ''),
                _row('Başvurduğu Akademik Kadro:', ''),
                _row('İmza:', ''),
              ],
            ),

            // FAALİYET DÖNEMİ SATIRLARI
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.85),
                1: pw.FractionColumnWidth(0.15),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        'Puanlanan Faaliyet Dönemi',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    pw.Text(''),
                  ],
                ),
                _row(
                  'Profesör (Doçent unvanını aldıktan sonraki faaliyetleri esas alınacaktır)',
                  '☐',
                ),
                _row(
                  'Doçent (Doktora / Sanatta yeterlik / tıp-diş uzmanlık unvanını aldıktan sonraki faaliyetleri esas alınacaktır)',
                  '☐',
                ),
                _row(
                  'Dr. Öğretim Üyesi (Yeniden Atama: Son atama tarihinden başvuru tarihine kadar olan faaliyetler esas alınacaktır)',
                  '☐',
                ),
                _row('Dr. Öğretim Üyesi (İlk Atama)', '☐'),
              ],
            ),

            // HER MADDE İÇİN TABLO
            // A. Makaleler Başlık

            // Başlık satırı (sadece bir kez)
            // BAŞLIK (tek hücre, tam genişlik)
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                top: pw.BorderSide(),
                right: pw.BorderSide(),
                bottom: pw.BorderSide(
                  width: 0,
                ), // altta çizgi olmasın, alt tabloya birleşsin
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'A. Makaleler (Başvurulan bilim alanı ile ilgili tam araştırma ve derleme makaleleri)',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ALT TABLO (başlık + veriler)
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(
                  width: 0,
                ), // üst çizgi olmasın, üst tabloyla birleşsin
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
              columnWidths: {
                0: pw.FractionColumnWidth(0.40),
                1: pw.FractionColumnWidth(0.40),
                2: pw.FractionColumnWidth(0.10),
                3: pw.FractionColumnWidth(0.10),
              },
              children: [
                // BAŞLIK SATIRI
                pw.TableRow(
                  children: [
                    pw.Container(), // açıklama başlığı boş
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Yazar/Yazarlar, Makale adı, Dergi adı, Cilt No., Sayfa, Yıl',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Puan Hesabı',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Nihai Puan',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // VERİ SATIRLARI
                ...articleDescriptions.map((desc) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          desc,
                          style: pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.5),
                1: pw.FractionColumnWidth(0.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Asgari Koşula Dahil Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // NOTLAR

            // B. Bilimsel Toplantı Faaliyetleri
            // BAŞLIK
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                top: pw.BorderSide(),
                right: pw.BorderSide(),
                bottom: pw.BorderSide(width: 0),
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'B. Bilimsel Toplantı Faaliyetleri (Başvurulan bilim alanı ile ilgili)',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // İÇERİK TABLOSU
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(width: 0),
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
              columnWidths: {
                0: pw.FractionColumnWidth(0.40),
                1: pw.FractionColumnWidth(0.40),
                2: pw.FractionColumnWidth(0.10),
                3: pw.FractionColumnWidth(0.10),
              },
              children: [
                // BAŞLIK SATIRI
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Yazar/Yazarlar, Bildiri adı, Konferans, Yer, Sayfa, Tarih',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Puan Hesabı',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Nihai Puan',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // VERİ SATIRLARI
                ...[
                  '1) Uluslararası bilimsel toplantılarda sözlü olarak sunulan, tam metni matbu veya elektronik olarak bildiri kitapçığında yayımlanmış çalışmalar',
                  '2) Uluslararası bilimsel toplantılarda sözlü olarak sunulan, özet metni matbu veya elektronik olarak bildiri kitapçığında yayımlanmış çalışmalar',
                  '3) Uluslararası toplantılarda poster bildiriler',
                  '4) Ulusal bilimsel toplantılarda sözlü olarak sunulan tam metni matbu veya elektronik olarak bildiri kitapçığında yayımlanmış çalışmalar',
                  '5) Ulusal bilimsel toplantılarda sözlü olarak sunulan, özet metni matbu veya elektronik olarak bildiri kitapçığında yayımlanmış çalışmalar',
                  '6) Ulusal toplantılarda poster bildiriler',
                  '7) Uluslararası bir kongre, konferans veya sempozyumda organizasyon veya yürütme komitesinde düzenleme kurulu üyeliği veya bilim kurulu üyeliği yapmak',
                  '8) Ulusal bir kongre, konferans veya sempozyumda organizasyon veya yürütme komitesinde düzenleme kurulu üyeliği veya bilim kurulu üyeliği yapmak',
                  '9) Uluslararası konferanslarda, bilimsel toplantı, seminerlerde davetli konuşmacı olarak yer almak',
                  '10) Ulusal konferanslarda, bilimsel toplantı, seminerlerde davetli konuşmacı olarak yer almak',
                  '11) Uluslararası veya ulusal çeşitli kurumlarla işbirliği içinde atölye, çalıştay, yaz okulu organize ederek gerçekleştirmek',
                  '11) Uluslararası veya ulusal çeşitli kurumlarla işbirliği içinde atölye, çalıştay, yaz okulu organize ederek gerçekleştirmek',
                ].map((desc) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          desc,
                          style: pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            // PUAN TABLOSU
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.5),
                1: pw.FractionColumnWidth(0.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Asgari Koşula Dahil Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // C. Kitaplar ve Kitap Bölümleri
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                top: pw.BorderSide(),
                right: pw.BorderSide(),
                bottom: pw.BorderSide(width: 0),
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'C. Kitaplar ve Kitap Bölümleri (Başvurulan bilim alanı ile ilgili)',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(width: 0),
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
              columnWidths: {
                0: pw.FractionColumnWidth(0.40),
                1: pw.FractionColumnWidth(0.40),
                2: pw.FractionColumnWidth(0.10),
                3: pw.FractionColumnWidth(0.10),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Yazar/Yazarlar, Kitap adı, Yayınevi, Basım Yılı, ISBN',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Puan Hesabı',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Nihai Puan',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...[
                  '1) Uluslararası yayınevleri tarafından yayımlanmış özgün kitap (bilim alanı ile ilgili)',
                  '2) Uluslararası yayınevleri tarafından yayımlanmış özgün kitap editörlüğü, bölüm yazarlığı (Her bir kitap için maksimum 2 bölüm yazarlığı)',
                  '3) Uluslararası yayımlanan ansiklopedi konusu/maddesi (en fazla 3 madde)',
                  '4) Ulusal yayınevleri tarafından yayımlanmış özgün kitap (bilim alanı ile ilgili)',
                  '5) Ulusal yayınevleri tarafından yayımlanmış özgün kitap editörlüğü, bölüm yazarlığı (Her bir kitap için maksimum 2 bölüm yazarlığı)',
                  '6) Tam kitap çevirisi (Yayınevleri için ilgili ÜAK kriterleri geçerlidir)',
                  '7) Çeviri kitap editörlüğü, kitap bölümü çevirisi (Yayınevleri için ilgili ÜAK kriterleri geçerlidir) (Her bir kitap için maksimum 2 bölüm çevirisi)',
                  '8) Alanında ulusal yayımlanan ansiklopedi konusu/maddesi (en fazla 3 madde)',
                  '9) Diğer kitap türleri',
                ].map((desc) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          desc,
                          style: pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.5),
                1: pw.FractionColumnWidth(0.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Asgari Koşula Dahil Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // D. Yayınlara Yapılan Atıflar
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                top: pw.BorderSide(),
                right: pw.BorderSide(),
                bottom: pw.BorderSide(width: 0),
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'D. Yayınlara Yapılan Atıflar (Başvurulan bilim alanı ile ilgili)',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(width: 0),
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
              columnWidths: {
                0: pw.FractionColumnWidth(0.40),
                1: pw.FractionColumnWidth(0.40),
                2: pw.FractionColumnWidth(0.10),
                3: pw.FractionColumnWidth(0.10),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Yazar/Yazarlar, Atıf Yapılan Çalışma Bilgisi',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Puan Hesabı',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Nihai Puan',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...[
                  '1) SCI-E, SSCI veya AHCI kapsamındaki dergilerde yayımlanan makaleye yapılan atıf',
                  '2) ESCI veya Scopus kapsamındaki dergilerde yayımlanan makaleye yapılan atıf',
                  '3) TR Dizin kapsamındaki dergilerde yayımlanan makaleye yapılan atıf',
                  '4) Ulusal diğer dergilerde yayımlanan makaleye yapılan atıf',
                  '5) Kitap veya kitap bölümüne yapılan atıf',
                  '6) Tezlere yapılan atıf',
                  '7) Diğer atıflar',
                ].map((desc) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          desc,
                          style: pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            // PUAN TABLOSU
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.5),
                1: pw.FractionColumnWidth(0.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Asgari Koşula Dahil Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // E. Eğitim-Öğretim Faaliyetleri
            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                top: pw.BorderSide(),
                right: pw.BorderSide(),
                bottom: pw.BorderSide(width: 0),
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.grey300,
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'E. Eğitim-Öğretim Faaliyetleri (Başvurulan bilim alanı ile ilgili)',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(width: 0),
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
              columnWidths: {
                0: pw.FractionColumnWidth(0.40),
                1: pw.FractionColumnWidth(0.40),
                2: pw.FractionColumnWidth(0.10),
                3: pw.FractionColumnWidth(0.10),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Faaliyet Açıklaması',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Puan Hesabı',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Nihai Puan',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                ...[
                  '1) Ön lisans / lisans dersleri (yıl bazında)',
                  '2) Ön lisans / lisans dersleri (yabancı dil)'
                      '3) Lisansüstü dersleri (yıl bazında)',
                  '4) Lisansüstü dersleri (yabancı dil)',
                ].map((desc) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(
                          desc,
                          style: pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text('', style: pw.TextStyle(fontSize: 7.5)),
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FractionColumnWidth(0.5),
                1: pw.FractionColumnWidth(0.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Asgari Koşula Dahil Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        'Toplam Puanı',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '___________',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// Yardımcı fonksiyon (üst alanlar için)
pw.TableRow _row(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(label, style: pw.TextStyle(fontSize: 8)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(value, style: pw.TextStyle(fontSize: 8)),
      ),
    ],
  );
}
