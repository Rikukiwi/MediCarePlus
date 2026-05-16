namespace MediCarePlus.Models
{
    public class Doctor
    {
        public int Id { get; set; }
        public string Name { get; set; } = "";
        public string Specialty { get; set; } = "";
        public int Experience { get; set; }
        public string Degree { get; set; } = "";
        public string Description { get; set; } = "";
        public string Initials { get; set; } = "";
        public string AvatarBg { get; set; } = "#DBEAFE";
        public string AvatarFg { get; set; } = "#1D4ED8";
        public double Rating { get; set; }
        public int ReviewCount { get; set; }
        public string? PhotoUrl { get; set; }
        public string PhotoPosition { get; set; } = "center center";
    }
}
