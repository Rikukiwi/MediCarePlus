using Microsoft.Data.SqlClient;
using MediCarePlus.Models;

namespace MediCarePlus.Data
{
    public class DatabaseHelper
    {
        private readonly string _conn;

        public DatabaseHelper(IConfiguration config)
        {
            _conn = config.GetConnectionString("DefaultConnection")
                    ?? throw new InvalidOperationException("Chuoi ket noi 'DefaultConnection' chua duoc cau hinh.");
        }

        private SqlConnection OpenConnection()
        {
            // Somee can timeout lon hon
            var builder = new SqlConnectionStringBuilder(_conn);
            builder.ConnectTimeout = 30;
            var conn = new SqlConnection(builder.ConnectionString);
            conn.Open();
            return conn;
        }

        // ================================================================
        // NGUOI DUNG
        // ================================================================

        /// <summary>Dang ky nguoi dung moi. Tra ve (Id moi, thong bao) hoac (-1, loi).</summary>
        public (int result, string message) DangKy(string hoTen, string email, string sdt, string matKhauHash)
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_DangKyNguoiDung", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@HoTen",       hoTen);
            cmd.Parameters.AddWithValue("@Email",       email);
            cmd.Parameters.AddWithValue("@SoDienThoai", sdt);
            cmd.Parameters.AddWithValue("@MatKhauHash", matKhauHash);

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                // Dung Convert.ToInt32 vi SCOPE_IDENTITY tra ve Decimal
                return (Convert.ToInt32(reader["Result"]),
                        reader["Message"]?.ToString() ?? "");
            }
            return (-1, "Lỗi không xác định");
        }

        /// <summary>Dang nhap. Tra ve AppUser neu thanh cong, null neu sai.</summary>
        public AppUser? DangNhap(string email, string matKhauHash)
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_DangNhap", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Email",       email);
            cmd.Parameters.AddWithValue("@MatKhauHash", matKhauHash);

            using var reader = cmd.ExecuteReader();
            if (!reader.Read()) return null;

            return new AppUser
            {
                Id           = Convert.ToInt32(reader["Id"]),
                FullName     = reader["HoTen"]?.ToString()        ?? "",
                Email        = reader["Email"]?.ToString()        ?? "",
                Phone        = reader["SoDienThoai"]?.ToString()  ?? "",
                Role         = reader["VaiTro"]?.ToString()       ?? "User",
                CreatedAt    = Convert.ToDateTime(reader["NgayTao"]),
                PasswordHash = matKhauHash
            };
        }

        /// <summary>Lay danh sach nguoi dung (Admin).</summary>
        public List<AppUser> LayTatCaNguoiDung()
        {
            var list = new List<AppUser>();
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_LayTatCaNguoiDung", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                list.Add(new AppUser
                {
                    Id        = Convert.ToInt32(reader["Id"]),
                    FullName  = reader["HoTen"]?.ToString()       ?? "",
                    Email     = reader["Email"]?.ToString()       ?? "",
                    Phone     = reader["SoDienThoai"]?.ToString() ?? "",
                    Role      = reader["VaiTro"]?.ToString()      ?? "User",
                    CreatedAt = Convert.ToDateTime(reader["NgayTao"])
                });
            }
            return list;
        }

        // ================================================================
        // LICH HEN
        // ================================================================

        /// <summary>Lay tat ca lich hen (Admin).</summary>
        public List<Appointment> LayTatCaLichHen()
        {
            var list = new List<Appointment>();
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_LayTatCaLichHen", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var reader = cmd.ExecuteReader();
            while (reader.Read()) list.Add(DocLichHen(reader));
            return list;
        }

        /// <summary>Lay lich hen cua 1 nguoi dung theo email.</summary>
        public List<Appointment> LayLichHenCuaNguoiDung(string email)
        {
            var list = new List<Appointment>();
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_LayLichHenCuaNguoiDung", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Email", email);
            using var reader = cmd.ExecuteReader();
            while (reader.Read()) list.Add(DocLichHen(reader));
            return list;
        }

        /// <summary>Dat lich kham moi. Tra ve Id moi.</summary>
        public int DatLich(Appointment a, int nguoiDungId)
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_DatLichKham", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@TenBenhNhan", a.PatientName);
            cmd.Parameters.AddWithValue("@SoDienThoai", a.Phone);
            cmd.Parameters.AddWithValue("@Email",       (object?)a.Email      ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@ChuyenKhoa",  a.Specialty);
            cmd.Parameters.AddWithValue("@TenBacSi",    (object?)a.DoctorName ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@NgayKham",    a.AppointmentDate);
            cmd.Parameters.AddWithValue("@GioKham",     a.AppointmentTime);
            cmd.Parameters.AddWithValue("@GhiChu",      (object?)a.Note       ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@NguoiDungId", nguoiDungId);
            var result = cmd.ExecuteScalar();
            return result != null ? Convert.ToInt32(result) : 0;
        }

        /// <summary>Cap nhat trang thai lich hen.</summary>
        public void CapNhatTrangThai(int id, string trangThai)
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_CapNhatTrangThaiLichHen", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Id",        id);
            cmd.Parameters.AddWithValue("@TrangThai", trangThai);
            cmd.ExecuteNonQuery();
        }

        // ================================================================
        // TIN NHAN LIEN HE
        // ================================================================

        public void LuuTinNhan(string hoTen, string sdt, string? chuDe, string noiDung)
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_LuuTinNhanLienHe", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@HoTen",       hoTen);
            cmd.Parameters.AddWithValue("@SoDienThoai", sdt);
            cmd.Parameters.AddWithValue("@ChuDe",       (object?)chuDe ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@NoiDung",     noiDung);
            cmd.ExecuteNonQuery();
        }

        // ================================================================
        // THONG KE DASHBOARD
        // ================================================================

        public DashboardStats LayThongKe()
        {
            using var conn = OpenConnection();
            using var cmd  = new SqlCommand("sp_ThongKeDashboard", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            using var reader = cmd.ExecuteReader();
            if (!reader.Read()) return new DashboardStats();
            return new DashboardStats
            {
                TongBacSi     = Convert.ToInt32(reader["TongBacSi"]),
                TongLichHen   = Convert.ToInt32(reader["TongLichHen"]),
                ChoXacNhan    = Convert.ToInt32(reader["ChoXacNhan"]),
                DaXacNhan     = Convert.ToInt32(reader["DaXacNhan"]),
                DaHuy         = Convert.ToInt32(reader["DaHuy"]),
                TongNguoiDung = Convert.ToInt32(reader["TongNguoiDung"]),
                LichHenHomNay = Convert.ToInt32(reader["LichHenHomNay"])
            };
        }

        // ================================================================
        // PRIVATE HELPER
        // ================================================================

        private static Appointment DocLichHen(SqlDataReader r) => new()
        {
            Id              = Convert.ToInt32(r["Id"]),
            PatientName     = r["TenBenhNhan"]?.ToString()  ?? "",
            Phone           = r["SoDienThoai"]?.ToString()  ?? "",
            Email           = r["Email"]      == DBNull.Value ? null : r["Email"].ToString(),
            Specialty       = r["ChuyenKhoa"]?.ToString()   ?? "",
            DoctorName      = r["TenBacSi"]   == DBNull.Value ? null : r["TenBacSi"].ToString(),
            AppointmentDate = Convert.ToDateTime(r["NgayKham"]),
            AppointmentTime = r["GioKham"]?.ToString()      ?? "",
            Note            = r["GhiChu"]     == DBNull.Value ? null : r["GhiChu"].ToString(),
            Status          = r["TrangThai"]?.ToString()    ?? "",
            CreatedAt       = Convert.ToDateTime(r["NgayTao"])
        };
    }

    public class DashboardStats
    {
        public int TongBacSi     { get; set; }
        public int TongLichHen   { get; set; }
        public int ChoXacNhan    { get; set; }
        public int DaXacNhan     { get; set; }
        public int DaHuy         { get; set; }
        public int TongNguoiDung { get; set; }
        public int LichHenHomNay { get; set; }
    }
}
