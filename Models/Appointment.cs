using System.ComponentModel.DataAnnotations;
namespace MediCarePlus.Models
{
    public class Appointment
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        [Display(Name = "Họ và tên")]
        public string PatientName { get; set; } = "";
        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^[0-9]{9,11}$", ErrorMessage = "Số điện thoại không hợp lệ")]
        [Display(Name = "Số điện thoại")]
        public string Phone { get; set; } = "";
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string? Email { get; set; }
        [Required(ErrorMessage = "Vui lòng chọn chuyên khoa")]
        [Display(Name = "Chuyên khoa")]
        public string Specialty { get; set; } = "";
        public string? DoctorName { get; set; }
        [Required(ErrorMessage = "Vui lòng chọn ngày khám")]
        [DataType(DataType.Date)]
        [Display(Name = "Ngày khám")]
        public DateTime AppointmentDate { get; set; }
        [Required(ErrorMessage = "Vui lòng chọn giờ khám")]
        [Display(Name = "Giờ khám")]
        public string AppointmentTime { get; set; } = "";
        public string? Note { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public string Status { get; set; } = "Chờ xác nhận";
    }
}
