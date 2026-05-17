-- ================================================================
--  MEDICARE+ v2 - SQL SERVER DATABASE SCRIPT
--  Cap nhat: Them cac truong moi, sua stored procedures
--  Chay trong SQL Server Management Studio (SSMS)
-- ================================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MediCarePlusDB')
BEGIN
    CREATE DATABASE MediCarePlusDB;
    PRINT '>>> Database MediCarePlusDB da duoc tao.';
END
ELSE
    PRINT '>>> Database MediCarePlusDB da ton tai.';
GO

USE MediCarePlusDB;
GO

-- ================================================================
--  BANG: NguoiDung
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NguoiDung')
BEGIN
    CREATE TABLE NguoiDung (
        Id           INT            IDENTITY(1,1) PRIMARY KEY,
        HoTen        NVARCHAR(100)  NOT NULL,
        Email        NVARCHAR(150)  NOT NULL UNIQUE,
        SoDienThoai  NVARCHAR(20)   NOT NULL,
        MatKhauHash  NVARCHAR(256)  NOT NULL,
        VaiTro       NVARCHAR(20)   NOT NULL DEFAULT 'User',
        NgayTao      DATETIME       NOT NULL DEFAULT GETDATE(),
        TrangThai    BIT            NOT NULL DEFAULT 1
    );
    PRINT '>>> Bang NguoiDung da duoc tao.';
END
ELSE
    PRINT '>>> Bang NguoiDung da ton tai.';
GO

-- ================================================================
--  BANG: BacSi
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
        ChuViet       NVARCHAR(5)    NULL,
        AvatarBg      NVARCHAR(20)   NULL DEFAULT '#DBEAFE',
        AvatarFg      NVARCHAR(20)   NULL DEFAULT '#1D4ED8',
        DanhGia       DECIMAL(3,1)   NOT NULL DEFAULT 5.0,
        SoLuotDanhGia INT            NOT NULL DEFAULT 0,
        UrlAnh        NVARCHAR(500)  NULL,
        ViTriAnh      NVARCHAR(50)   NULL DEFAULT 'center center',
        TrangThai     BIT            NOT NULL DEFAULT 1
    );
    PRINT '>>> Bang BacSi da duoc tao.';
END
ELSE
    PRINT '>>> Bang BacSi da ton tai.';
GO

-- ================================================================
--  BANG: LichHen
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
        NguoiDungId  INT            NULL,
        CONSTRAINT FK_LichHen_NguoiDung
            FOREIGN KEY (NguoiDungId) REFERENCES NguoiDung(Id)
    );
    PRINT '>>> Bang LichHen da duoc tao.';
END
ELSE
    PRINT '>>> Bang LichHen da ton tai.';
GO

-- ================================================================
--  BANG: TinNhanLienHe
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
    PRINT '>>> Bang TinNhanLienHe da duoc tao.';
END
ELSE
    PRINT '>>> Bang TinNhanLienHe da ton tai.';
GO

-- ================================================================
--  BANG: DichVu
-- ================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DichVu')
BEGIN
    CREATE TABLE DichVu (
        Id        INT            IDENTITY(1,1) PRIMARY KEY,
        TenDichVu NVARCHAR(100)  NOT NULL,
        MoTa      NVARCHAR(500)  NULL,
        MauNen    NVARCHAR(20)   NULL DEFAULT '#DBEAFE',
        MauIcon   NVARCHAR(20)   NULL DEFAULT '#2563EB',
        UrlMedia  NVARCHAR(500)  NULL,
        ThuTu     INT            NOT NULL DEFAULT 0,
        TrangThai BIT            NOT NULL DEFAULT 1
    );
    PRINT '>>> Bang DichVu da duoc tao.';
END
ELSE
    PRINT '>>> Bang DichVu da ton tai.';
GO

-- ================================================================
--  DU LIEU MAU
-- ================================================================

-- Admin mac dinh
-- Mat khau: Admin@123
-- Hash SHA256 se duoc tao khi dang ky qua web roi UPDATE VaiTro
IF NOT EXISTS (SELECT * FROM NguoiDung WHERE Email = 'admin@medicare.vn')
BEGIN
    -- Dang ky qua web roi chay lenh nay:
    -- UPDATE NguoiDung SET VaiTro='Admin' WHERE Email='admin@medicare.vn'
    PRINT '>>> Chua co admin. Hay dang ky tai admin@medicare.vn / Admin@123 qua web roi chay:';
    PRINT '    UPDATE NguoiDung SET VaiTro=''Admin'' WHERE Email=''admin@medicare.vn''';
END
ELSE
    PRINT '>>> Admin da ton tai.';
GO

-- Bac si mau
IF NOT EXISTS (SELECT * FROM BacSi WHERE HoTen = N'BS.CKII Nguyễn Văn An')
BEGIN
    INSERT INTO BacSi (HoTen, ChuyenKhoa, KinhNghiem, BangCap, MoTa, ChuViet, AvatarBg, AvatarFg, DanhGia, SoLuotDanhGia, UrlAnh)
    VALUES
    (N'BS.CKII Nguyễn Văn An',  N'Tim mạch',       15, N'Tiến sĩ Y khoa',  N'Chuyên gia tim mạch can thiệp, siêu âm tim và đặt stent động mạch vành. Từng tu nghiệp tại Đại học Tokyo.',    'NA','#DBEAFE','#1D4ED8',4.9,312,'/images/doctors/doctor1.png'),
    (N'PGS.TS Trần Thị Bình',   N'Nội tổng quát',  22, N'Phó Giáo sư',     N'Chuyên điều trị bệnh nội khoa, tiểu đường type 2, huyết áp và rối loạn chuyển hóa.',                           'TB','#CFFAFE','#0E7490',4.8,456,'/images/doctors/doctor2.png'),
    (N'BS.CKI Lê Minh Cường',   N'Nhi khoa',       12, N'Thạc sĩ Y khoa',  N'Bác sĩ nhi tận tâm, giàu kinh nghiệm chẩn đoán và điều trị bệnh trẻ sơ sinh và trẻ nhỏ.',                      'LC','#D1FAE5','#065F46',4.9,289,'/images/doctors/doctor3.png'),
    (N'TS.BS Phạm Thu Hà',      N'Phụ sản',        18, N'Tiến sĩ Y khoa',  N'Chuyên gia siêu âm thai 4D, điều trị vô sinh hiếm muộn và phẫu thuật nội soi phụ khoa.',                       'PH','#FCE7F3','#9D174D',5.0,521,'/images/doctors/doctor4.png'),
    (N'BS.CKI Hoàng Đức Thịnh', N'Thần kinh',      10, N'Thạc sĩ Y khoa',  N'Chuyên điều trị đau đầu mạn tính, tai biến mạch máu não, Parkinson và động kinh.',                             'HT','#EDE9FE','#5B21B6',4.7,198,'/images/doctors/doctor5.png'),
    (N'BS.CKI Vũ Thị Lan',      N'Da liễu',         9, N'Thạc sĩ Y khoa',  N'Chuyên gia da liễu thẩm mỹ: điều trị mụn, nám, vảy nến, chàm và chăm sóc da chuyên sâu.',                     'VL','#FEF3C7','#92400E',4.8,267,'/images/doctors/doctor6.png');
    PRINT '>>> Du lieu mau Bac Si da duoc them.';
END
ELSE
    PRINT '>>> Du lieu mau Bac Si da ton tai.';
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
    (N'Nhãn khoa',     N'Kiểm tra thị lực, Lasik, đục thủy tinh thể',        '#ECFDF5','#10B981','/images/services/mat.gif',       8);
    PRINT '>>> Du lieu mau Dich Vu da duoc them.';
END
ELSE
    PRINT '>>> Du lieu mau Dich Vu da ton tai.';
GO

-- ================================================================
--  STORED PROCEDURES
-- ================================================================

-- SP: Dang ky nguoi dung
CREATE OR ALTER PROCEDURE sp_DangKyNguoiDung
    @HoTen       NVARCHAR(100),
    @Email       NVARCHAR(150),
    @SoDienThoai NVARCHAR(20),
    @MatKhauHash NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM NguoiDung WHERE Email = @Email)
    BEGIN
        SELECT CAST(-1 AS INT) AS Result, N'Email đã được đăng ký' AS Message;
        RETURN;
    END
    INSERT INTO NguoiDung (HoTen, Email, SoDienThoai, MatKhauHash, VaiTro, NgayTao)
    VALUES (@HoTen, @Email, @SoDienThoai, @MatKhauHash, 'User', GETDATE());
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS Result, N'Đăng ký thành công' AS Message;
END
GO

-- SP: Dang nhap
CREATE OR ALTER PROCEDURE sp_DangNhap
    @Email       NVARCHAR(150),
    @MatKhauHash NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        Id, HoTen, Email, SoDienThoai, VaiTro, NgayTao
    FROM NguoiDung
    WHERE Email        = @Email
      AND MatKhauHash  = @MatKhauHash
      AND TrangThai    = 1;
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
    SET NOCOUNT ON;
    INSERT INTO LichHen
        (TenBenhNhan, SoDienThoai, Email, ChuyenKhoa, TenBacSi,
         NgayKham, GioKham, GhiChu, TrangThai, NgayTao, NguoiDungId)
    VALUES
        (@TenBenhNhan, @SoDienThoai, @Email, @ChuyenKhoa, @TenBacSi,
         @NgayKham, @GioKham, @GhiChu, N'Chờ xác nhận', GETDATE(), @NguoiDungId);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewId;
END
GO

-- SP: Cap nhat trang thai lich hen
CREATE OR ALTER PROCEDURE sp_CapNhatTrangThaiLichHen
    @Id        INT,
    @TrangThai NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE LichHen SET TrangThai = @TrangThai WHERE Id = @Id;
END
GO

-- SP: Lay tat ca lich hen (Admin)
CREATE OR ALTER PROCEDURE sp_LayTatCaLichHen
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        lh.Id, lh.TenBenhNhan, lh.SoDienThoai, lh.Email,
        lh.ChuyenKhoa, lh.TenBacSi, lh.NgayKham, lh.GioKham,
        lh.GhiChu, lh.TrangThai, lh.NgayTao,
        nd.HoTen AS TenTaiKhoan
    FROM LichHen lh
    LEFT JOIN NguoiDung nd ON lh.NguoiDungId = nd.Id
    ORDER BY lh.NgayTao DESC;
END
GO

-- SP: Lay lich hen theo email nguoi dung
CREATE OR ALTER PROCEDURE sp_LayLichHenCuaNguoiDung
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM LichHen
    WHERE Email = @Email
    ORDER BY NgayTao DESC;
END
GO

-- SP: Lay tat ca nguoi dung (Admin)
CREATE OR ALTER PROCEDURE sp_LayTatCaNguoiDung
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, HoTen, Email, SoDienThoai, VaiTro, NgayTao, TrangThai
    FROM NguoiDung
    WHERE VaiTro = 'User'
    ORDER BY NgayTao DESC;
END
GO

-- SP: Thong ke Dashboard
CREATE OR ALTER PROCEDURE sp_ThongKeDashboard
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM BacSi  WHERE TrangThai = 1)                              AS TongBacSi,
        (SELECT COUNT(*) FROM LichHen)                                                  AS TongLichHen,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Chờ xác nhận')               AS ChoXacNhan,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Đã xác nhận')                AS DaXacNhan,
        (SELECT COUNT(*) FROM LichHen WHERE TrangThai = N'Đã huỷ')                     AS DaHuy,
        (SELECT COUNT(*) FROM NguoiDung WHERE VaiTro = 'User' AND TrangThai = 1)       AS TongNguoiDung,
        (SELECT COUNT(*) FROM LichHen
         WHERE CAST(NgayKham AS DATE) = CAST(GETDATE() AS DATE))                       AS LichHenHomNay;
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
    SET NOCOUNT ON;
    INSERT INTO TinNhanLienHe (HoTen, SoDienThoai, ChuDe, NoiDung, NgayGui, DaXem)
    VALUES (@HoTen, @SoDienThoai, @ChuDe, @NoiDung, GETDATE(), 0);
END
GO

-- ================================================================
--  VIEWS HUU ICH
-- ================================================================
CREATE OR ALTER VIEW vw_LichHenDayDu AS
SELECT
    lh.Id, lh.TenBenhNhan, lh.SoDienThoai, lh.Email,
    lh.ChuyenKhoa, lh.TenBacSi,
    CONVERT(NVARCHAR(10), lh.NgayKham, 103) AS NgayKhamStr,
    lh.GioKham, lh.GhiChu, lh.TrangThai,
    CONVERT(NVARCHAR(16), lh.NgayTao, 120) AS NgayTaoStr,
    nd.HoTen AS TenTaiKhoan, nd.VaiTro
FROM LichHen lh
LEFT JOIN NguoiDung nd ON lh.NguoiDungId = nd.Id;
GO

-- ================================================================
--  LENH HUU ICH
-- ================================================================

-- Xem tat ca lich hen
-- SELECT * FROM vw_LichHenDayDu ORDER BY NgayTaoStr DESC;

-- Cap quyen Admin (chay sau khi dang ky qua web)
-- UPDATE NguoiDung SET VaiTro='Admin' WHERE Email='admin@medicare.vn';

-- Xoa admin cu va tao lai
-- DELETE FROM NguoiDung WHERE Email='admin@medicare.vn';
-- (Sau do dang ky lai qua web roi UPDATE VaiTro='Admin')

-- Reset trang thai lich hen
-- UPDATE LichHen SET TrangThai=N'Chờ xác nhận' WHERE Id=1;

-- ================================================================
--  KIEM TRA KET QUA
-- ================================================================
SELECT 'NguoiDung'     AS Bang, COUNT(*) AS SoBanGhi FROM NguoiDung     UNION ALL
SELECT 'BacSi'         AS Bang, COUNT(*) AS SoBanGhi FROM BacSi         UNION ALL
SELECT 'LichHen'       AS Bang, COUNT(*) AS SoBanGhi FROM LichHen       UNION ALL
SELECT 'DichVu'        AS Bang, COUNT(*) AS SoBanGhi FROM DichVu        UNION ALL
SELECT 'TinNhanLienHe' AS Bang, COUNT(*) AS SoBanGhi FROM TinNhanLienHe;

PRINT '';
PRINT '================================================================';
PRINT ' MEDICARE+ DATABASE v2 TRIEN KHAI THANH CONG';
PRINT ' Stored Procedures: 8 SP';
PRINT ' Views: 1 View';
PRINT '================================================================';
PRINT ' TAO ADMIN:';
PRINT ' 1. Dang ky tai web voi admin@medicare.vn / Admin@123';
PRINT ' 2. Chay: UPDATE NguoiDung SET VaiTro=''Admin'' WHERE Email=''admin@medicare.vn''';
PRINT '================================================================';
GO
