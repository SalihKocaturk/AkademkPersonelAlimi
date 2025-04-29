const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// MySQL bağlantısı
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'akademik_portal_db',
    timezone: '-03:00'

});

// Bağlantı kontrolü
db.connect((err) => {
    if (err) {
        console.error('Veritabanına bağlanılamadı:', err);
    } else {
        console.log('MySQL bağlantısı başarılı!');
    }
});

// Middleware
app.use(cors());
app.use(bodyParser.json());

// --- API ROUTES ---
//
//
//
//
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
                });
            } else {
                return res.status(401).send('Giriş başarısız');
            }
        }
    );
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

// Server başlat
app.listen(port, () => {
    console.log(`Server http://localhost:${port} üzerinde çalışıyor`);
});
