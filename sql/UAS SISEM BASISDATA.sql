CREATE DATABASE IF NOT EXISTS toko_bangunan;
USE toko_bangunan;

CREATE TABLE pelanggan (
    id_pelanggan VARCHAR(10) PRIMARY KEY,
    nama_pembeli VARCHAR(100) NOT NULL
);

CREATE TABLE barang (
    id_barang VARCHAR(10) PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    harga DECIMAL(12,2) NOT NULL
);

CREATE TABLE transaksi (
    no_transaksi VARCHAR(20) PRIMARY KEY,
    tanggal DATE NOT NULL,
    id_pelanggan VARCHAR(10) NOT NULL,
    jenis_pengiriman VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

CREATE TABLE detail_transaksi (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    no_transaksi VARCHAR(20) NOT NULL,
    id_barang VARCHAR(10) NOT NULL,
    jumlah_barang INT NOT NULL,
    FOREIGN KEY (no_transaksi) REFERENCES transaksi(no_transaksi),
    FOREIGN KEY (id_barang) REFERENCES barang(id_barang)
);



INSERT INTO pelanggan (id_pelanggan, nama_pembeli) VALUES
('PLG001', 'Mas Agus');

INSERT INTO barang (id_barang, nama_barang, harga) VALUES
('BRG001', 'Pasir', 208000),
('BRG002', 'Tali Tambang', 6000),
('BRG003', 'Ember Oranye', 9000),
('BRG004', 'Semen', 52000),
('BRG005', 'Solasi', 3500);

INSERT INTO transaksi (no_transaksi, tanggal, id_pelanggan, jenis_pengiriman) VALUES
('701', '2025-09-08', 'PLG001', 'diantar'),
('702', '2025-09-08', 'PLG001', 'ambil_sendiri'),
('703', '2025-09-08', 'PLG001', 'ambil_sendiri'),
('704', '2025-09-08', 'PLG001', 'diantar'),
('705', '2025-09-08', 'PLG001', 'ambil_sendiri');

INSERT INTO detail_transaksi (no_transaksi, id_barang, jumlah_barang) VALUES
('701', 'BRG001', 1),
('702', 'BRG002', 1),
('703', 'BRG003', 5),
('704', 'BRG004', 15),
('705', 'BRG005', 2);



SHOW TABLES;

DESCRIBE pelanggan;
DESCRIBE barang;
DESCRIBE transaksi;
DESCRIBE detail_transaksi;


SELECT 
    t.no_transaksi,
    t.tanggal,
    p.nama_pembeli,
    b.nama_barang,
    dt.jumlah_barang,
    b.harga,
    (dt.jumlah_barang * b.harga) AS total
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang
ORDER BY t.tanggal, t.no_transaksi;

select*from detail_transaksi;

SELECT 
no_transaksi,
tanggal,
jenis_pengiriman
FROM transaksi
ORDER BY tanggal DESC, jenis_pengiriman ASC;


SELECT DISTINCT jenis_pengiriman
FROM transaksi;

SELECT
tanggal,
id_pelanggan,
jenis_pengiriman
FROM transaksi
WHERE jenis_pengiriman = 'diantar' 
AND tanggal = '2025-09-08'
OR id_pelanggan = 'PLG001';

SELECT 
id_barang,
nama_barang,
harga
FROM barang
WHERE nama_barang LIKE '%em%';

SELECT 
no_transaksi,
jumlah_barang,
id_barang
FROM detail_transaksi
WHERE jumlah_barang BETWEEN 2 AND 10;


SELECT 
t.no_transaksi AS 'Nomor Transaksi',
t.tanggal AS 'Tanggal',
b.nama_barang AS 'Nama Barang',
dt.jumlah_barang AS 'Jumlah',
b.harga AS 'Harga Satuan',
(dt.jumlah_barang * b.harga) AS 'Total Harga'
FROM transaksi t
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang;


SELECT 
COUNT(*) AS 'Jumlah Transaksi',
SUM(dt.jumlah_barang) AS 'Total Barang Terjual',
AVG(b.harga) AS 'Rata-rata Harga Barang',
MIN(b.harga) AS 'Harga Terendah',
MAX(b.harga) AS 'Harga Tertinggi'
FROM transaksi t
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang;


SELECT 
t.jenis_pengiriman AS 'Jenis Pengiriman',
COUNT(t.no_transaksi) AS 'Jumlah Transaksi',
SUM(dt.jumlah_barang) AS 'Total Barang Terjual'
FROM transaksi t
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
GROUP BY t.jenis_pengiriman;

SELECT 
dt.id_barang AS 'Kode Barang',
b.nama_barang AS 'Nama Barang',
SUM(dt.jumlah_barang) AS 'Total Terjual'
FROM detail_transaksi dt
JOIN barang b ON dt.id_barang = b.id_barang
GROUP BY dt.id_barang, b.nama_barang
HAVING SUM(dt.jumlah_barang) > 5;


SELECT 
t.id_pelanggan AS 'Kode Pelanggan',
p.nama_pembeli AS 'Nama Pelanggan',
COUNT(DISTINCT t.no_transaksi) AS 'Frekuensi Beli',
SUM(dt.jumlah_barang) AS 'Total Barang Dibeli',
SUM(dt.jumlah_barang * b.harga) AS 'Total Belanja'
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang
GROUP BY t.id_pelanggan, p.nama_pembeli
HAVING SUM(dt.jumlah_barang * b.harga) > 100000;


SELECT transaksi.no_transaksi, transaksi.tanggal, pelanggan.nama_pembeli
FROM transaksi
INNER JOIN pelanggan
ON transaksi.id_pelanggan = pelanggan.id_pelanggan;

SELECT transaksi.no_transaksi, transaksi.tanggal, pelanggan.nama_pembeli
FROM transaksi, pelanggan
WHERE transaksi.id_pelanggan = pelanggan.id_pelanggan;

SELECT no_transaksi, tanggal, nama_pembeli
FROM transaksi
JOIN pelanggan
USING (id_pelanggan);

SELECT no_transaksi, tanggal, nama_pembeli
FROM transaksi
NATURAL JOIN pelanggan;

SELECT transaksi.no_transaksi, pelanggan.nama_pembeli
FROM transaksi
LEFT JOIN pelanggan
ON transaksi.id_pelanggan = pelanggan.id_pelanggan;

SELECT pelanggan.id_pelanggan, pelanggan.nama_pembeli, transaksi.no_transaksi
FROM transaksi
RIGHT JOIN pelanggan
ON transaksi.id_pelanggan = pelanggan.id_pelanggan;

SELECT pelanggan.id_pelanggan, pelanggan.nama_pembeli, transaksi.no_transaksi
FROM pelanggan
LEFT JOIN transaksi
ON pelanggan.id_pelanggan = transaksi.id_pelanggan
UNION
SELECT pelanggan.id_pelanggan, pelanggan.nama_pembeli, transaksi.no_transaksi
FROM pelanggan
RIGHT JOIN transaksi
ON pelanggan.id_pelanggan = transaksi.id_pelanggan;

SELECT transaksi.no_transaksi, barang.nama_barang, detail_transaksi.jumlah_barang
FROM detail_transaksi
INNER JOIN transaksi
ON detail_transaksi.no_transaksi = transaksi.no_transaksi
INNER JOIN barang
ON detail_transaksi.id_barang = barang.id_barang;


SELECT t.no_transaksi, t.tanggal, p.nama_pembeli, 
       b.nama_barang, dt.jumlah_barang, b.harga,
       (dt.jumlah_barang * b.harga) AS total
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang
ORDER BY t.tanggal, t.no_transaksi;




SELECT t.id_pelanggan, p.nama_pembeli,
       COUNT(DISTINCT t.no_transaksi) AS frekuensi_beli,
       SUM(dt.jumlah_barang) AS total_barang,
       SUM(dt.jumlah_barang * b.harga) AS total_belanja
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.no_transaksi = dt.no_transaksi
JOIN barang b ON dt.id_barang = b.id_barang
GROUP BY t.id_pelanggan, p.nama_pembeli
HAVING SUM(dt.jumlah_barang * b.harga) > 100000;



