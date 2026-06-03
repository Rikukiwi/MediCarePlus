using MediCarePlus.Models;
using System.Security.Cryptography;
using System.Text;

namespace MediCarePlus.Data
{
    public static class UserStore
    {
        private static readonly List<AppUser> _users = new();
        private static readonly object _lock = new();

        static UserStore()
        {
            // Tao admin mac dinh khi khoi dong app
            _users.Add(new AppUser
            {
                Id = 0,
                FullName = "Quản trị viên",
                Email = "admin@medicare.vn",
                Phone = "0901234567",
                PasswordHash = Hash("Admin@123"),
                Role = "Admin",
                CreatedAt = DateTime.Now
            });
        }

        private static string Hash(string input)
            => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(input)));

        public static AppUser? FindByEmailAndPassword(string email, string passwordHash)
        {
            lock (_lock)
            {
                return _users.FirstOrDefault(u =>
                    u.Email.ToLower() == email.ToLower() &&
                    u.PasswordHash == passwordHash);
            }
        }

        public static bool EmailExists(string email)
        {
            lock (_lock)
            {
                return _users.Any(u => u.Email.ToLower() == email.ToLower());
            }
        }

        public static void Add(AppUser user)
        {
            lock (_lock)
            {
                user.Id = _users.Count + 1;
                _users.Add(user);
            }
        }

        public static List<AppUser> GetAll()
        {
            lock (_lock)
            {
                return _users.Where(u => u.Role == "User")
                             .OrderByDescending(u => u.CreatedAt)
                             .ToList();
            }
        }
    }
}