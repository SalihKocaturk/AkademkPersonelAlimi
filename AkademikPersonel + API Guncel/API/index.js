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



app.listen(port, () => {
  console.log(`Sunucu ${port} portunda çalışıyor.`);
});
