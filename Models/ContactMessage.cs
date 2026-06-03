using System.ComponentModel.DataAnnotations;
namespace MediCarePlus.Models
{
    public class ContactMessage
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string Name { get; set; } = "";
        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        public string Phone { get; set; } = "";
        public string? Subject { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập nội dung")]
        public string Message { get; set; } = "";
    }
}
