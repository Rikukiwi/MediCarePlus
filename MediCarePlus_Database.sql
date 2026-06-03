-- ================================================================
--  Rau Má+ - SQL SERVER DATABASE SCRIPT
--  Chay script nay trong SQL Server Management Studio (SSMS)
--  Tuong thich: SQL Server 2016+, SQL Server Express, LocalDB
-- ================================================================

USE master;
GO

-- Tao database neu chua ton tai
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MediCarePlusDB')
BEGIN
    CREATE DATABASE MediCarePlusDB;
    PRINT 'Database MediCarePlusDB da duoc tao.';
END
ELSE
BEGIN
    PRINT 'Database MediCarePlusDB da ton tai.';
END
GO

USE MediCarePlusDB;
GO

-- ================================================================
--  BANG 1: NguoiDung (Users)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NguoiDung')
BEGIN
    CREATE TABLE NguoiDung (
        Id           INT            IDENTITY(1,1) PRIMARY KEY,
        HoTen        NVARCHAR(100)  NOT NULL,
        Email        NVARCHAR(150)  NOT NULL UNIQUE,
        SoDienThoai  NVARCHAR(20)   NOT NULL,
        MatKhauHash  NVARCHAR(256)  NOT NULL,
        VaiTro       NVARCHAR(20)   NOT NULL DEFAULT 'User',  -- 'User' hoac 'Admin'
        NgayTao      DATETIME       NOT NULL DEFAULT GETDATE(),
        TrangThai    BIT            NOT NULL DEFAULT 1        -- 1: Hoat dong, 0: Khoa
    );
    PRINT 'Bang NguoiDung da duoc tao.';
END
GO

-- ================================================================
--  BANG 2: BacSi (Doctors)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BacSi')
BEGIN
    CREATE TABLE BacSi (
        Id            INT            IDENTITY(1,1) PRIMARY KEY,
        HoTen         NVARCHAR(150)  NOT NULL,
        ChuyenKhoa    NVARCHAR(100)  NOT NULL,
        KinhNghiem    INT            NOT NULL DEFAULT 0,
        BangCap       NVARCHAR(100)  NOT NULL,
        MoTa          NVARCHAR(MAX)  NULL,
        ChuViet       NVARCHAR(5)    NULL,          -- Avatar chu cai
        AvatarBg      NVARCHAR(20)   NULL DEFAULT '#DBEAFE',
        AvatarFg      NVARCHAR(20)   NULL DEFAULT '#1D4ED8',
        DanhGia       DECIMAL(3,1)   NOT NULL DEFAULT 5.0,
        SoLuotDanhGia INT            NOT NULL DEFAULT 0,
        UrlAnh        NVARCHAR(500)  NULL,
        ViTriAnh      NVARCHAR(50)   NULL DEFAULT 'center center',
        TrangThai     BIT            NOT NULL DEFAULT 1
    );
    PRINT 'Bang BacSi da duoc tao.';
END
GO

-- ================================================================
--  BANG 3: LichHen (Appointments)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LichHen')
BEGIN
    CREATE TABLE LichHen (
        Id           INT            IDENTITY(1,1) PRIMARY KEY,
        TenBenhNhan  NVARCHAR(100)  NOT NULL,
        SoDienThoai  NVARCHAR(20)   NOT NULL,
        Email        NVARCHAR(150)  NULL,
        ChuyenKhoa   NVARCHAR(100)  NOT NULL,
        TenBacSi     NVARCHAR(150)  NULL,
        NgayKham     DATE           NOT NULL,
        GioKham      NVARCHAR(10)   NOT NULL,
        GhiChu       NVARCHAR(500)  NULL,
        TrangThai    NVARCHAR(50)   NOT NULL DEFAULT N'Chờ xác nhận',
        NgayTao      DATETIME       NOT NULL DEFAULT GETDATE(),
        NguoiDungId  INT            NULL,           -- Khoa ngoai lien ket NguoiDung
        CONSTRAINT FK_LichHen_NguoiDung
            FOREIGN KEY (NguoiDungId) REFERENCES NguoiDung(Id)
    );
    PRINT 'Bang LichHen da duoc tao.';
END
GO

-- ================================================================
--  BANG 4: TinNhanLienHe (Contact Messages)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TinNhanLienHe')
BEGIN
    CREATE TABLE TinNhanLienHe (
        Id          INT            IDENTITY(1,1) PRIMARY KEY,
        HoTen       NVARCHAR(100)  NOT NULL,
        SoDienThoai NVARCHAR(20)   NOT NULL,
        ChuDe       NVARCHAR(200)  NULL,
        NoiDung     NVARCHAR(MAX)  NOT NULL,
        NgayGui     DATETIME       NOT NULL DEFAULT GETDATE(),
        DaXem       BIT            NOT NULL DEFAULT 0
    );
    PRINT 'Bang TinNhanLienHe da duoc tao.';
END
GO

-- ================================================================
--  BANG 5: DichVu (Services)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DichVu')
BEGIN
    CREATE TABLE DichVu (
        Id          INT            IDENTITY(1,1) PRIMARY KEY,
        TenDichVu   NVARCHAR(100)  NOT NULL,
        MoTa        NVARCHAR(500)  NULL,
        MauNen      NVARCHAR(20)   NULL DEFAULT '#DBEAFE',
        MauIcon     NVARCHAR(20)   NULL DEFAULT '#2563EB',
        UrlMedia    NVARCHAR(500)  NULL,
        ThuTu       INT            NOT NULL DEFAULT 0,
        TrangThai   BIT            NOT NULL DEFAULT 1
    );
    PRINT 'Bang DichVu da duoc tao.';
END
GO

-- ================================================================
--  BANG 6: DanhGiaBacSi (Doctor Reviews)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DanhGiaBacSi')
BEGIN
    CREATE TABLE DanhGiaBacSi (
        Id          INT            IDENTITY(1,1) PRIMARY KEY,
        BacSiId     INT            NOT NULL,
        TenNguoiDG  NVARCHAR(100)  NOT NULL,
        SoSao       INT            NOT NULL DEFAULT 5,
        NhanXet     NVARCHAR(500)  NULL,
        NgayDanhGia DATETIME       NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_DanhGia_BacSi
            FOREIGN KEY (BacSiId) REFERENCES BacSi(Id)
    );
    PRINT 'Bang DanhGiaBacSi da duoc tao.';
END
GO

-- ================================================================
--  DU LIEU MAU
-- ================================================================

-- Admin mac dinh (mat khau: Admin@123 da duoc hash SHA256)
IF NOT EXISTS (SELECT * FROM NguoiDung WHERE Email = 'admin@medicare.vn')
BEGIN
    INSERT INTO NguoiDung (HoTen, Email, SoDienThoai, MatKhauHash, VaiTro)
    VALUES (
        N'Quản trị viên',
        'admin@medicare.vn',
        '0901234567',
        -- SHA256 cua "Admin@123"
        '4F5B3E97A1FD5264A87C05CA05F56D52A1F6E2DE8DB2A7E35E53D7A89F0A8EF6',
        'Admin'
    );
    PRINT 'Admin mac dinh da duoc tao.';
END
GO

-- Bac si mau
IF NOT EXISTS (SELECT * FROM BacSi WHERE HoTen = N'BS.CKII Nguyễn Văn An')
BEGIN
    INSERT INTO BacSi (HoTen, ChuyenKhoa, KinhNghiem, BangCap, MoTa, ChuViet, AvatarBg, AvatarFg, DanhGia, SoLuotDanhGia, UrlAnh)
    VALUES
    (N'BS.CKII Nguyễn Văn An',  N'Tim mạch',      15, N'Tiến sĩ Y khoa', N'Chuyên gia tim mạch can thiệp, siêu âm tim và đặt stent động mạch vành. Từng tu nghiệp tại Đại học Tokyo.', 'NA', '#DBEAFE','#1D4ED8', 4.9, 312, '/images/doctors/doctor1.png'),
    (N'PGS.TS Trần Thị Bình',   N'Nội tổng quát', 22, N'Phó Giáo sư',    N'Chuyên điều trị bệnh nội khoa, tiểu đường type 2, huyết áp và rối loạn chuyển hóa.',                       'TB', '#CFFAFE','#0E7490', 4.8, 456, '/images/doctors/doctor2.png'),
    (N'BS.CKI Lê Minh Cường',   N'Nhi khoa',      12, N'Thạc sĩ Y khoa', N'Bác sĩ nhi tận tâm, giàu kinh nghiệm chẩn đoán và điều trị bệnh trẻ sơ sinh và trẻ nhỏ.',                   'LC', '#D1FAE5','#065F46', 4.9, 289, '/images/doctors/doctor3.png'),
    (N'TS.BS Phạm Thu Hà',      N'Phụ sản',       18, N'Tiến sĩ Y khoa', N'Chuyên gia siêu âm thai 4D, điều trị vô sinh hiếm muộn và phẫu thuật nội soi phụ khoa.',                    'PH', '#FCE7F3','#9D174D', 5.0, 521, '/images/doctors/doctor4.png'),
    (N'BS.CKI Hoàng Đức Thịnh', N'Thần kinh',     10, N'Thạc sĩ Y khoa', N'Chuyên điều trị đau đầu mạn tính, tai biến mạch máu não, Parkinson và động kinh.',                          'HT', '#EDE9FE','#5B21B6', 4.7, 198, '/images/doctors/doctor5.png'),
    (N'BS.CKI Vũ Thị Lan',      N'Da liễu',        9, N'Thạc sĩ Y khoa', N'Chuyên gia da liễu thẩm mỹ: điều trị mụn, nám, vảy nến, chàm và chăm sóc da chuyên sâu.',                  'VL', '#FEF3C7','#92400E', 4.8, 267, '/images/doctors/doctor6.png');

    PRINT 'Du lieu mau Bac Si da duoc them.';
END
GO

-- Dich vu mau
IF NOT EXISTS (SELECT * FROM DichVu WHERE TenDichVu = N'Tim mạch')
BEGIN
    INSERT INTO DichVu (TenDichVu, MoTa, MauNen, MauIcon, UrlMedia, ThuTu)
    VALUES
    (N'Tim mạch',      N'Điện tâm đồ, siêu âm tim, Holter, đặt stent',       '#FEE2E2','#DC2626','/images/services/timbach.gif',  1),
    (N'Nội tổng quát', N'Khám định kỳ, tiểu đường, huyết áp, mỡ máu',        '#DBEAFE','#2563EB','/images/services/noi.gif',       2),
    (N'Nhi khoa',      N'Chăm sóc toàn diện trẻ em từ sơ sinh – 16 tuổi',    '#D1FAE5','#059669','/images/services/nhi.gif',       3),
    (N'Phụ sản',       N'Siêu âm thai 4D, theo dõi thai kỳ, phụ khoa',       '#FCE7F3','#DB2777','/images/services/phusan.gif',    4),
    (N'Thần kinh',     N'Đau đầu, mất ngủ, tai biến, Parkinson',             '#EDE9FE','#7C3AED','/images/services/thankinh.gif',  5),
    (N'Da liễu',       N'Mụn, nám, chàm, vảy nến, thẩm mỹ da',              '#FEF3C7','#D97706','/images/services/dalieu.gif',    6),
    (N'Răng hàm mặt',  N'Implant, niềng răng, tẩy trắng, nhổ khôn',         '#CFFAFE','#0891B2','/images/services/rang.gif',      7),
    (N'Nhãn khoa',     N'Kiểm tra thị lực, Lasik, đục thủy tinh thể',        '#ECFDF5','#10B981','/images/services/mat.gif',      8);

    PRINT 'Du lieu mau Dich Vu da duoc them.';
END
GO

-- ================================================================
--  STORED PROCEDURES
-- ================================================================

-- SP: Lay tat ca lich hen (Admin)
CREATE OR ALTER PROCEDURE sp_LayTatCaLichHen
AS
BEGIN
    SELECT
        lh.Id,
        lh.TenBenhNhan,
        lh.SoDienThoai,
        lh.Email,
        lh.ChuyenKhoa,
        lh.TenBacSi,
        lh.NgayKham,
        lh.GioKham,
        lh.GhiChu,
        lh.TrangThai,
        lh.NgayTao,
        nd.HoTen AS TenTaiKhoan
    FROM LichHen lh
    LEFT JOIN NguoiDung nd ON lh.NguoiDungId = nd.Id
    ORDER BY lh.NgayTao DESC;
END
GO

-- SP: Lay lich hen cua 1 nguoi dung
CREATE OR ALTER PROCEDURE sp_LayLichHenCuaNguoiDung
    @Email NVARCHAR(150)
AS
BEGIN
    SELECT *
    FROM LichHen
    WHERE Email = @Email
    ORDER BY NgayTao DESC;
END
GO

-- SP: Dat lich kham
CREATE OR ALTER PROCEDURE sp_DatLichKham
    @TenBenhNhan NVARCHAR(100),
    @SoDienThoai NVARCHAR(20),
    @Email       NVARCHAR(150),
    @ChuyenKhoa  NVARCHAR(100),
    @TenBacSi    NVARCHAR(150),
    @NgayKham    DATE,
    @GioKham     NVARCHAR(10),
    @GhiChu      NVARCHAR(500),
    @NguoiDungId INT
AS
BEGIN
    INSERT INTO LichHen
        (TenBenhNhan, SoDienThoai, Email, ChuyenKhoa, TenBacSi, NgayKham, GioKham, GhiChu, TrangThai, NgayTao, NguoiDungId)
    VALUES
        (@TenBenhNhan, @SoDienThoai, @Email, @ChuyenKhoa, @TenBacSi, @NgayKham, @GioKham, @GhiChu, N'Chờ xác nhận', GETDATE(), @NguoiDungId);

    SELECT SCOPE_IDENTITY() AS NewId;
END
GO

-- SP: Cap nhat trang thai lich hen
CREATE OR ALTER PROCEDURE sp_CapNhatTrangThaiLichHen
    @Id       INT,
    @TrangThai NVARCHAR(50)
AS
BEGIN
    UPDATE LichHen
    SET TrangThai = @TrangThai
    WHERE Id = @Id;
END
GO

-- SP: Dang ky nguoi dung
CREATE OR ALTER PROCEDURE sp_DangKyNguoiDung
    @HoTen       NVARCHAR(100),
    @Email       NVARCHAR(150),
    @SoDienThoai NVARCHAR(20),
    @MatKhauHash NVARCHAR(256)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NguoiDung WHERE Email = @Email)
    BEGIN
        SELECT -1 AS Result, N'Email đã được đăng ký' AS Message;
        RETURN;
    END

    INSERT INTO NguoiDung (HoTen, Email, SoDienThoai, MatKhauHash, VaiTro, NgayTao)
    VALUES (@HoTen, @Email, @SoDienThoai, @MatKhauHash, 'User', GETDATE());

    SELECT SCOPE_IDENTITY() AS Result, N'Đăng ký thành công' AS Message;
END
GO

-- SP: Dang nhap
CREATE OR ALTER PROCEDURE sp_DangNhap
    @Email       NVARCHAR(150),
    @MatKhauHash NVARCHAR(256)
AS
BEGIN
    SELECT Id, HoTen, Email, SoDienThoai, VaiTro, NgayTao
    FROM NguoiDung
    WHERE Email = @Email
      AND MatKhauHash = @MatKhauHash
      AND TrangThai = 1;
END
GO

-- SP: Thong ke Dashboard Admin
CREATE OR ALTER PROCEDURE sp_ThongKeDashboard
AS
BEGIN
    SELECT
        (SELECT COUNT(*) FROM BacSi  WHERE TrangThai = 1)                             AS TongBacSi,
        (SELECT COUNT(*) FROM LichHen)                                                 AS TongLichHen,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Chờ xác nhận')              AS ChoXacNhan,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Đã xác nhận')               AS DaXacNhan,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Đã huỷ')                    AS DaHuy,
        (SELECT COUNT(*) FROM NguoiDung WHERE VaiTro = 'User' AND TrangThai = 1)      AS TongNguoiDung,
        (SELECT COUNT(*) FROM LichHen WHERE CAST(NgayKham AS DATE) = CAST(GETDATE() AS DATE)) AS LichHenHomNay;
END
GO

-- SP: Lay tat ca nguoi dung (Admin)
CREATE OR ALTER PROCEDURE sp_LayTatCaNguoiDung
AS
BEGIN
    SELECT Id, HoTen, Email, SoDienThoai, VaiTro, NgayTao, TrangThai
    FROM NguoiDung
    WHERE VaiTro = 'User'
    ORDER BY NgayTao DESC;
END
GO

-- SP: Lay tin nhan lien he
CREATE OR ALTER PROCEDURE sp_LayTinNhanLienHe
AS
BEGIN
    SELECT * FROM TinNhanLienHe ORDER BY NgayGui DESC;
END
GO

-- SP: Luu tin nhan lien he
CREATE OR ALTER PROCEDURE sp_LuuTinNhanLienHe
    @HoTen       NVARCHAR(100),
    @SoDienThoai NVARCHAR(20),
    @ChuDe       NVARCHAR(200),
    @NoiDung     NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO TinNhanLienHe (HoTen, SoDienThoai, ChuDe, NoiDung, NgayGui, DaXem)
    VALUES (@HoTen, @SoDienThoai, @ChuDe, @NoiDung, GETDATE(), 0);
END
GO

-- ================================================================
--  VIEWS HU ICH
-- ================================================================

-- View: Lich hen day du
CREATE OR ALTER VIEW vw_LichHenDayDu AS
SELECT
    lh.Id,
    lh.TenBenhNhan,
    lh.SoDienThoai,
    lh.Email,
    lh.ChuyenKhoa,
    lh.TenBacSi,
    lh.NgayKham,
    lh.GioKham,
    lh.GhiChu,
    lh.TrangThai,
    lh.NgayTao,
    nd.HoTen AS TenTaiKhoan,
    nd.VaiTro
FROM LichHen lh
LEFT JOIN NguoiDung nd ON lh.NguoiDungId = nd.Id;
GO

-- View: Thong ke lich hen theo ngay
CREATE OR ALTER VIEW vw_ThongKeLichHenTheoNgay AS
SELECT
    CAST(NgayKham AS DATE) AS Ngay,
    COUNT(*) AS TongLich,
    SUM(CASE WHEN TrangThai = N'Đã xác nhận' THEN 1 ELSE 0 END) AS DaXacNhan,
    SUM(CASE WHEN TrangThai = N'Chờ xác nhận' THEN 1 ELSE 0 END) AS ChoXacNhan,
    SUM(CASE WHEN TrangThai = N'Đã huỷ' THEN 1 ELSE 0 END) AS DaHuy
FROM LichHen
GROUP BY CAST(NgayKham AS DATE);
GO

-- ================================================================
--  KIEM TRA KET QUA
-- ================================================================
PRINT '';
PRINT '====== KIEM TRA DU LIEU ======';

SELECT 'NguoiDung'     AS Bang, COUNT(*) AS SoBanGhi FROM NguoiDung     UNION ALL
SELECT 'BacSi'         AS Bang, COUNT(*) AS SoBanGhi FROM BacSi         UNION ALL
SELECT 'DichVu'        AS Bang, COUNT(*) AS SoBanGhi FROM DichVu        UNION ALL
SELECT 'LichHen'       AS Bang, COUNT(*) AS SoBanGhi FROM LichHen       UNION ALL
SELECT 'TinNhanLienHe' AS Bang, COUNT(*) AS SoBanGhi FROM TinNhanLienHe UNION ALL
SELECT 'DanhGiaBacSi'  AS Bang, COUNT(*) AS SoBanGhi FROM DanhGiaBacSi;

PRINT '';
PRINT '====== DATABASE Rau Má+ DA TRIEN KHAI THANH CONG ======';
PRINT 'Cac bang: NguoiDung, BacSi, LichHen, DichVu, TinNhanLienHe, DanhGiaBacSi';
PRINT 'Stored Procedures: 9 SP da duoc tao';
PRINT 'Views: 2 View da duoc tao';
PRINT '';
PRINT 'Tai khoan Admin mac dinh:';
PRINT '  Email   : admin@medicare.vn';
PRINT '  Mat khau: Admin@123';
GO
