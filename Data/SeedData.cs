using MediCarePlus.Models;
namespace MediCarePlus.Data
{
    public static class SeedData
    {
        public static List<Doctor> GetDoctors() => new()
        {
            new Doctor { Id=1, Name="BS.CKII Nguyễn Minh Huy",   Specialty="Tim mạch",      Experience=15, Degree="Tiến sĩ Y khoa",  Initials="NA", AvatarBg="#DBEAFE", AvatarFg="#1D4ED8", Rating=4.9, ReviewCount=312, Description="Chuyên gia tim mạch can thiệp, siêu âm tim và đặt stent động mạch vành. Từng tu nghiệp tại Đại học Tokyo.", PhotoUrl="/images/doctors/doctor1.png" },
            new Doctor { Id=2, Name="PGS.TS Nguyễn Thanh Hải",    Specialty="Nội tổng quát", Experience=22, Degree="Phó Giáo sư",     Initials="TB", AvatarBg="#CFFAFE", AvatarFg="#0E7490", Rating=4.8, ReviewCount=456, Description="Chuyên điều trị bệnh nội khoa, tiểu đường type 2, huyết áp và rối loạn chuyển hóa.", PhotoUrl="/images/doctors/doctor2.png" },
            new Doctor { Id=3, Name="BS.CKI Trần Nhựt Đăng Khôi",    Specialty="Nhi khoa",      Experience=12, Degree="Thạc sĩ Y khoa",  Initials="LC", AvatarBg="#D1FAE5", AvatarFg="#065F46", Rating=4.9, ReviewCount=289, Description="Bác sĩ nhi tận tâm, giàu kinh nghiệm chẩn đoán và điều trị bệnh trẻ sơ sinh và trẻ nhỏ.", PhotoUrl="/images/doctors/doctor3.png" },
            new Doctor { Id=4, Name="TS.BS Lê Hồng Minh",       Specialty="Phụ sản",       Experience=18, Degree="Tiến sĩ Y khoa",  Initials="PH", AvatarBg="#FCE7F3", AvatarFg="#9D174D", Rating=5.0, ReviewCount=521, Description="Chuyên gia siêu âm thai 4D, điều trị vô sinh hiếm muộn và phẫu thuật nội soi phụ khoa.", PhotoUrl="/images/doctors/doctor4.png" },
            new Doctor { Id=5, Name="BS.CKI Nguyễn Danh Vọng",  Specialty="Thần kinh",     Experience=10, Degree="Thạc sĩ Y khoa",  Initials="HT", AvatarBg="#EDE9FE", AvatarFg="#5B21B6", Rating=4.7, ReviewCount=198, Description="Chuyên điều trị đau đầu mạn tính, tai biến mạch máu não, Parkinson và động kinh.", PhotoUrl="/images/doctors/doctor5.png" },
            new Doctor { Id=6, Name="BS.CKI Nguyễn Ngọc Trâm",       Specialty="Da liễu",       Experience=9,  Degree="Thạc sĩ Y khoa",  Initials="VL", AvatarBg="#FEF3C7", AvatarFg="#92400E", Rating=4.8, ReviewCount=267, Description="Chuyên gia da liễu thẩm mỹ: điều trị mụn, nám, vảy nến, chàm và chăm sóc da chuyên sâu.", PhotoUrl="/images/doctors/doctor6.png" },
        };

        public static List<string> GetSpecialties() => new()
        { "Tất cả","Tim mạch","Nội tổng quát","Nhi khoa","Phụ sản","Thần kinh","Da liễu" };

        public static List<string> GetAppointmentTimes() => new()
        { "07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00" };

        // Title, Desc, Bg, IconColor, MediaUrl (đặt gif/png vào wwwroot/images/services/)
        public static List<(string Title, string Desc, string Bg, string IconColor, string MediaUrl)> GetServices() => new()
        {
            ("Tim mạch",      "Điện tâm đồ, siêu âm tim, Holter, đặt stent",       "#FEE2E2","#DC2626","/images/services/timbach.gif"),
            ("Nội tổng quát", "Khám định kỳ, tiểu đường, huyết áp, mỡ máu",        "#DBEAFE","#2563EB","/images/services/noi.gif"),
            ("Nhi khoa",      "Chăm sóc toàn diện trẻ em từ sơ sinh – 16 tuổi",    "#D1FAE5","#059669","/images/services/nhi.gif"),
            ("Phụ sản",       "Siêu âm thai 4D, theo dõi thai kỳ, phụ khoa",       "#FCE7F3","#DB2777","/images/services/phusan.gif"),
            ("Thần kinh",     "Đau đầu, mất ngủ, tai biến, Parkinson",             "#EDE9FE","#7C3AED","/images/services/thankinh.gif"),
            ("Da liễu",       "Mụn, nám, chàm, vảy nến, thẩm mỹ da",              "#FEF3C7","#D97706","/images/services/dalieu.gif"),
            ("Răng hàm mặt",  "Implant, niềng răng, tẩy trắng, nhổ khôn",         "#CFFAFE","#0891B2","/images/services/rang.gif"),
            ("Nhãn khoa",     "Kiểm tra thị lực, Lasik, đục thủy tinh thể",        "#ECFDF5","#10B981","/images/services/mat.gif"),
        };
    }
}
