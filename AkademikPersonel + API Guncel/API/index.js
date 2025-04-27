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
});

db.connect((err) => {
  if (err) {
    console.error('Database bağlantı hatası: ', err);
  } else {
    console.log('MySQL veritabanına başarıyla bağlandı.');
  }
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
app.post('/jurigiris', (req, res) => {
  const { TCKimlikNo, Sifre } = req.body;

  const query = `
    SELECT KullaniciID, Ad, Soyad, RolID
    FROM kullanicilar
    WHERE TCKimlikNo = ? AND Sifre = ? AND RolID = 4
  `;

  db.query(query, [TCKimlikNo, Sifre], (err, results) => {
    if (err) {
      console.error('Giriş hatası:', err);
      return res.status(500).json({ hata: 'Sunucu hatası' });
    }

    if (results.length === 0) {
      return res.status(401).json({ hata: 'Geçersiz bilgiler veya jüri yetkiniz yok.' });
    }

    const user = results[0];
    res.status(200).json({
      mesaj: 'Giriş başarılı',
      kullaniciID: user.KullaniciID,
      adSoyad: `${user.Ad} ${user.Soyad}`,
      rolID: user.RolID
    });
  });
});



app.listen(port, () => {
  console.log(`Sunucu ${port} portunda çalışıyor.`);
});
