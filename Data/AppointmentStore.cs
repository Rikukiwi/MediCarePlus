using MediCarePlus.Models;

namespace MediCarePlus.Data
{
    // Lưu lịch hẹn dùng chung cho tất cả user + admin
    public static class AppointmentStore
    {
        private static readonly List<Appointment> _list = new();
        private static readonly object _lock = new();

        public static List<Appointment> GetAll()
        {
            lock (_lock) { return _list.OrderByDescending(a => a.CreatedAt).ToList(); }
        }

        public static void Add(Appointment a)
        {
            lock (_lock)
            {
                a.Id = _list.Count + 1;
                _list.Insert(0, a);
            }
        }

        public static void UpdateStatus(int id, string status)
        {
            lock (_lock)
            {
                var a = _list.FirstOrDefault(x => x.Id == id);
                if (a != null) a.Status = status;
            }
        }
    }
}