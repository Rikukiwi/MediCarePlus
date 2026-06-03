using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
using MediCarePlus.Models;

namespace MediCarePlus.Controllers
{
    public class AdminController : Controller
    {
        private readonly DatabaseHelper _db;
        public AdminController(DatabaseHelper db) { _db = db; }

        private bool IsAdmin() => HttpContext.Session.GetString("UserRole") == "Admin";

        public IActionResult Index()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            var stats = _db.LayThongKe();
            ViewBag.TotalDoctors       = SeedData.GetDoctors().Count;
            ViewBag.TotalAppointments  = stats.TongLichHen;
            ViewBag.PendingCount       = stats.ChoXacNhan;
            ViewBag.TotalUsers         = stats.TongNguoiDung;
            ViewBag.LichHenHomNay      = stats.LichHenHomNay;
            ViewBag.RecentAppointments = _db.LayTatCaLichHen().Take(10).ToList();
            return View();
        }

        public IActionResult Appointments()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            ViewBag.Appointments = _db.LayTatCaLichHen();
            return View();
        }

        public IActionResult ConfirmAppointment(int id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            _db.CapNhatTrangThai(id, "Đã xác nhận");
            TempData["Success"] = "Đã xác nhận lịch hẹn!";
            return RedirectToAction("Appointments");
        }

        public IActionResult CancelAppointment(int id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            _db.CapNhatTrangThai(id, "Đã hủy");
            TempData["Success"] = "Đã hủy lịch hẹn!";
            return RedirectToAction("Appointments");
        }

        public IActionResult Doctors()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            ViewBag.Doctors = SeedData.GetDoctors();
            return View();
        }

        public IActionResult Users()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account");
            ViewBag.Users = _db.LayTatCaNguoiDung();
            return View();
        }
    }
}
