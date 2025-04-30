const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const cors = require('cors');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  timezone: '-03:00'
});

db.connect((err) => {
  if (err) {
    console.error('Database bağlantı hatası: ', err);
  } else {
    console.log('MySQL veritabanına başarıyla bağlandı.');
  }
});
// İlan işlemleri
// 1) İlanları çek (ilanlar tablosu)
app.get('/announcements', (req, res) => {
  db.query('SELECT * FROM ilanlar', (err, results) => {
      if (err) {
          console.error('İlanlar çekilemedi:', err);
          res.status(500).send('Server error');
      } else {
          res.json(results);
      }
  });
});

// 2) İlan ekle (ilanlar tablosu)
app.post('/announcements', (req, res) => {
  const { title, description, kadroTipiId, temelAlanId, startDate, endDate, requiredDocuments, olusturanAdminId } = req.body;
  const docs = JSON.stringify(requiredDocuments);
  console.log(title);

  db.query(
      'INSERT INTO ilanlar (Baslik, Aciklama, KadroTipiID, TemelAlanID, BaslangicTarihi, BitisTarihi, GerekliBelgeler, OlusturanAdminID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [title, description, kadroTipiId, temelAlanId, startDate, endDate, docs, olusturanAdminId],
      (err, results) => {
          if (err) {
              console.error('İlan eklenemedi:', err);
              res.status(500).send('Server error');
          } else {
              res.json({ id: results.insertId, message: 'İlan başarıyla eklendi' });
          }
      }
  );
});



// 3) İlan sil (ilanlar tablosu)
app.delete('/announcements/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM ilanlar WHERE IlanID = ?', [id], (err, results) => {
      if (err) {
          console.error('İlan silinemedi:', err);
          res.status(500).send('Server error');
      } else {
          res.json({ message: 'İlan başarıyla silindi' });
      }
  });
});

// 4) Başvuruları çek (basvurular tablosu)
app.get('/applications', (req, res) => {
  db.query('SELECT * FROM basvurular', (err, results) => {
      if (err) {
          console.error('Başvurular çekilemedi:', err);
          res.status(500).send('Server error');
      } else {
          res.json(results);
      }
  });
});

// 5) Başvuru yap (basvurular tablosu)
app.post('/applications', (req, res) => {
  const { announcementId, appliedAt } = req.body;

  db.query(
      'INSERT INTO basvurular (announcementId, appliedAt) VALUES (?, ?)',
      [announcementId, appliedAt],
      (err, results) => {
          if (err) {
              console.error('Başvuru yapılamadı:', err);
              res.status(500).send('Server error');
          } else {
              res.json({ id: results.insertId, message: 'Başvuru başarıyla kaydedildi' });
          }
      }
  );
});
//6) basvuuruları guncelle
app.put('/announcements/:id', (req, res) => {
  const { id } = req.params;
  const { Baslik, Aciklama, KadroTipiID, TemelAlanID, BaslangicTarihi, BitisTarihi, GerekliBelgeler, OlusturanAdminID } = req.body;

  console.log("Gelen veriler:", req.body);

  const docs = typeof GerekliBelgeler === 'string' ? GerekliBelgeler : JSON.stringify(GerekliBelgeler);
  const safeStartDate = BaslangicTarihi.split('T')[0];
  const safeEndDate = BitisTarihi.split('T')[0];
  db.query(
      'UPDATE ilanlar SET Baslik = ?, Aciklama = ?, KadroTipiID = ?, TemelAlanID = ?, BaslangicTarihi = ?, BitisTarihi = ?, GerekliBelgeler = ?, OlusturanAdminID = ? WHERE IlanID = ?',
      [Baslik, Aciklama, KadroTipiID, TemelAlanID, safeStartDate, safeEndDate, docs, OlusturanAdminID, id],
      (err, result) => {
          if (err) {
              console.error('Güncelleme hatası:', err);
              return res.status(500).send('Güncelleme hatası');
          }
          res.json({ message: 'İlan başarıyla güncellendi' });
      }
  );
});

app.get('/kadro-kriterleri', (req, res) => {
  const query = 'SELECT * FROM kadrokriterleri';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Kadro kriterleri çekilemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json(results);
  });
});

app.get('/kadro-kriterleri', (req, res) => {
  const query = `
    SELECT 
      KriterID, 
      KadroTipiID, 
      TemelAlanID, 
      FaaliyetKodu, 
      MinPuan, 
      MinSayi, 
      PuanDegeri
    FROM kadrokriterleri
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Kadro kriterleri çekilemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json(results);
  });
});

app.post('/kadro-kriterleri', (req, res) => {
  const {
    KadroTipiID,
    TemelAlanID,
    FaaliyetKodu,
    MinPuan,
    MinSayi,
    PuanDegeri
  } = req.body;

  const query = `
    INSERT INTO kadrokriterleri 
    (KadroTipiID, TemelAlanID, FaaliyetKodu, MinPuan, MinSayi, PuanDegeri)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(query, [KadroTipiID, TemelAlanID, FaaliyetKodu, MinPuan, MinSayi, PuanDegeri], (err, result) => {
    if (err) {
      console.error('Kadro kriteri eklenemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.status(201).json({ mesaj: 'Kadro kriteri başarıyla eklendi.' });
  });
});

app.put('/kadro-kriterleri/:id', (req, res) => {
  const { id } = req.params;
  const {
    KadroTipiID,
    TemelAlanID,
    FaaliyetKodu,
    MinPuan,
    MinSayi,
    PuanDegeri
  } = req.body;

  const query = `
    UPDATE kadrokriterleri 
    SET KadroTipiID=?, TemelAlanID=?, FaaliyetKodu=?, MinPuan=?, MinSayi=?, PuanDegeri=?
    WHERE KriterID=?
  `;

  db.query(query, [KadroTipiID, TemelAlanID, FaaliyetKodu, MinPuan, MinSayi, PuanDegeri, id], (err, result) => {
    if (err) {
      console.error('Kadro kriteri güncellenemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json({ mesaj: 'Kadro kriteri başarıyla güncellendi.' });
  });
});

app.delete('/kadro-kriterleri/:id', (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM kadrokriterleri WHERE KriterID = ?';

  db.query(query, [id], (err, result) => {
    if (err) {
      console.error('Kadro kriteri silinemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json({ mesaj: 'Kadro kriteri başarıyla silindi.' });
  });
});

//------------İLANLARI GÖRÜNTÜLE--------------------
app.get('/basvurular', (req, res) => {
  const query = `
    SELECT 
      b.BasvuruID,
      b.BasvuruTarihi,
      b.Durum,
      b.ToplamPuan,
      b.SonGuncelleme,
      k.Ad AS AdayAd,
      k.Soyad AS AdaySoyad,
      i.IlanID,
      i.Baslik AS IlanBaslik,
      i.BaslangicTarihi,
      i.BitisTarihi
    FROM basvurular b
    JOIN kullanicilar k ON b.AdayID = k.KullaniciID
    JOIN ilanlar i ON b.IlanID = i.IlanID
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Başvurular alınamadı:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json(results);
  });
});

app.put('/basvurular/:basvuruID', (req, res) => {
  const basvuruID = req.params.basvuruID;
  const { yeniDurum } = req.body;

  const query = `
    UPDATE basvurular
    SET Durum = ?
    WHERE BasvuruID = ?
  `;

  db.query(query, [yeniDurum, basvuruID], (err, result) => {
    if (err) {
      console.error('Durum güncellenemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json({ mesaj: 'Durum başarıyla güncellendi' });
  });
});

// İlanları listeleme
app.get('/ilanlar', (req, res) => {
  const query = `SELECT IlanID, Baslik, Aciklama, BaslangicTarihi, BitisTarihi FROM ilanlar`;
  db.query(query, (err, results) => {
    if (err) {
      console.error('İlanlar çekilemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json(results);
  });
});

app.get('/kullanicijuri', (req, res) => {
  const query = `SELECT KullaniciID,Ad,Soyad, TCKimlikNo FROM kullanicilar WHERE RolID = 4`;
  db.query(query, (err, results) => {
    if (err) {
      console.error('İlanlar çekilemedi:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }
    res.json(results);
  });
});

app.post('/juri-atama', (req, res) => {
  const { IlanID, TCKimlikNo } = req.body;

  // Önce TC Kimlik No'ya göre KullaniciID bulunacak
  const findUserQuery = `
    SELECT KullaniciID 
    FROM kullanicilar 
    WHERE TCKimlikNo = ?
  `;

  db.query(findUserQuery, [TCKimlikNo], (err, results) => {
    if (err) {
      console.error('Kullanıcı bulunamadı:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }

    if (results.length === 0) {
      return res.status(404).json({ hata: 'TC Kimlik No ile kullanıcı bulunamadı.' });
    }

    const JuriUyesiID = results[0].KullaniciID;
    const AtayanYoneticiID = 4; // Şimdilik sabit atıyoruz

    const insertQuery = `
      INSERT INTO juriatamalari 
      (IlanID, JuriUyesiID, AtayanYoneticiID, AtamaTarihi)
      VALUES (?, ?, ?, NOW())
    `;

    db.query(insertQuery, [IlanID, JuriUyesiID, AtayanYoneticiID], (insertErr, insertResult) => {
      if (insertErr) {
        console.error('Atama yapılamadı:', insertErr);
        return res.status(500).json({ hata: 'Sunucu hatası' });
      }

      res.status(201).json({ mesaj: 'Jüri ataması başarıyla yapıldı.', atamaID: insertResult.insertId });
    });
  });
});
//-------------------------JÜRİ GİRİŞ VE VERİLER-----------------------------------

app.get('/juri-basvurular', (req, res) => {
  const sabitTC = '88888888888'; // Test için sabit TC

  const findUserQuery = `
    SELECT KullaniciID 
    FROM kullanicilar 
    WHERE TCKimlikNo = ?
  `;

  db.query(findUserQuery, [sabitTC], (err, userResults) => {
    if (err) {
      console.error('Kullanıcı aranırken hata:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }

    if (userResults.length === 0) {
      return res.status(404).json({ hata: 'Kullanıcı bulunamadı.' });
    }

    const juriID = userResults[0].KullaniciID;

    const findIlanQuery = `
      SELECT IlanID
      FROM juriatamalari
      WHERE JuriUyesiID = ?
    `;

    db.query(findIlanQuery, [juriID], (err, ilanResults) => {
      if (err) {
        console.error('İlanlar aranırken hata:', err);
        return res.status(500).json({ hata: 'Sunucu hatası' });
      }

      if (ilanResults.length === 0) {
        return res.status(404).json({ hata: 'Jüri ataması bulunamadı.' });
      }

      const ilanIDList = ilanResults.map(row => row.IlanID);
      const placeholders = ilanIDList.map(() => '?').join(', ');

      const findBasvuruQuery = `
        SELECT 
          b.BasvuruID,
          b.BasvuruTarihi,
          b.Durum,
          b.ToplamPuan,
          b.SonGuncelleme,
          k.Ad AS AdayAd,
          k.Soyad AS AdaySoyad,
          i.IlanID,
          i.Baslik AS IlanBaslik,
          ? AS JuriUyesiID
        FROM basvurular b
        JOIN kullanicilar k ON b.AdayID = k.KullaniciID
        JOIN ilanlar i ON b.IlanID = i.IlanID
        WHERE b.IlanID IN (${placeholders})
      `;

      const params = [juriID, ...ilanIDList];

      db.query(findBasvuruQuery, params, (err, basvuruResults) => {
        if (err) {
          console.error('Başvurular aranırken hata:', err);
          return res.status(500).json({ hata: 'Sunucu hatası' });
        }
        res.json(basvuruResults);
      });
    });
  });
});

app.post('/juri-degerlendirme', (req, res) => {
  const { BasvuruID, IlanID, JuriUyesiID,TcKimlikNo, Sonuc, Aciklama, DegerlendirmeRaporuYolu } = req.body;

  const insertQuery = `
    INSERT INTO juridegerlendirmeleri 
    (BasvuruID, IlanID, JuriUyesiID,TcKimlikNo, Sonuc, Aciklama, DegerlendirmeRaporuYolu, DegerlendirmeTarihi)
    VALUES (?, ?, ?, ?, ?,?,?, NOW())
  `;

  db.query(
    insertQuery,
    [BasvuruID, IlanID, JuriUyesiID, TcKimlikNo, Sonuc, Aciklama, DegerlendirmeRaporuYolu],
    (err, result) => {
      if (err) {
        console.error('Değerlendirme kaydedilemedi:', err);
        return res.status(500).json({ hata: 'Sunucu hatası' });
      }
      res.status(201).json({ mesaj: 'Değerlendirme başarıyla kaydedildi.', degerlendirmeID: result.insertId });
    }
  );
});



// Giriş kayıt olma ksmı
// 
// 
//
// Giriş yapma
app.post('/login', (req, res) => {
  const { tc, sifre } = req.body;

  db.query(
      'SELECT * FROM kullanicilar WHERE TCKimlikNo = ? AND Sifre = ?',
      [tc, sifre],
      (err, results) => {
          if (err) {
              console.error('Hata:', err);
              return res.status(500).send('Server error');
          }
          if (results.length > 0) {
              const user = results[0];
              return res.json({
                  rol: user.RolID == 1 ? 'Admin' :
                      user.RolID == 2 ? 'Yonetici' :
                          user.RolID == 3 ? 'Juri' : 'Aday',
                  ad: user.Ad,
                  soyad: user.Soyad,
                  tc: user.TCKimlikNo,
                  kullaniciID : user.KullaniciID
              });
          } else {
              return res.status(401).send('Giriş başarısız');
          }
      }
  );
});

app.get('/users/:tc', (req, res) => {
  const { tc } = req.params;
  db.query('SELECT Ad, Soyad FROM kullanicilar WHERE TCKimlikNo = ?', [tc], (err, results) => {
      if (err) {
          console.error('Kullanıcı çekilemedi:', err);
          res.status(500).send('Server error');
      } else if (results.length > 0) {
          res.json(results[0]);
      } else {
          res.status(404).send('Kullanıcı bulunamadı');
      }
  });
});
app.post('/register', (req, res) => {
  const { tc, ad, soyad, dogumYili, sifre, eposta, rolId } = req.body;

  db.query(
      'INSERT INTO kullanicilar (TCKimlikNo, Ad, Soyad, DogumYili, Sifre, Eposta, RolID) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [tc, ad, soyad, dogumYili, sifre, eposta, rolId],
      (err, result) => {
          if (err) {
              console.error('Kayıt hatası:', err);
              return res.status(500).send('Kayıt başarısız');
          }
          res.json({ message: 'Kayıt başarılı' });
      }
  );
});





app.listen(port, () => {
  console.log(`Sunucu ${port} portunda çalışıyor.`);
});
