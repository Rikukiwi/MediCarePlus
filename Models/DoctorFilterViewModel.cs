namespace MediCarePlus.Models
{
    public class DoctorFilterViewModel
    {
        public List<Doctor> Doctors { get; set; } = new();
        public string SelectedSpecialty { get; set; } = "Tất cả";
        public List<string> Specialties { get; set; } = new();
    }
}
