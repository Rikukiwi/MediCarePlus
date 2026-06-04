    using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
using MediCarePlus.Models;

namespace MediCarePlus.Controllers
{
    public class BookingController : Controller
    {
        private readonly DatabaseHelper _db;
        public BookingController(DatabaseHelper db) { _db = db; }

        private bool IsLoggedIn() => HttpContext.Session.GetString("UserEmail") != null;

        [HttpGet]
        public IActionResult Index()
        {
            if (!IsLoggedIn())
            {
                TempData["LoginRequired"] = "Vui lòng đăng nhập để đặt lịch khám!";
                return RedirectToAction("Login", "Account");
            }

            ViewBag.Specialties = SeedData.GetSpecialties().Where(s => s != "Tất cả").ToList();
            ViewBag.Doctors = SeedData.GetDoctors();
            ViewBag.Times = SeedData.GetAppointmentTimes();

            var email = HttpContext.Session.GetString("UserEmail") ?? "";
            ViewBag.Appointments = _db.LayLichHenCuaNguoiDung(email);

            var model = new Appointment();

            // Lay dung ten tu session
            var userName = HttpContext.Session.GetString("UserName") ?? "";
            // Neu UserName la email thi de trong cho user tu nhap
            model.PatientName = userName.Contains("@") ? "" : userName;
            model.Email = email;

            return View(model);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public IActionResult Index(Appointment model)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");
            if (model.AppointmentDate < DateTime.Today)
                ModelState.AddModelError("AppointmentDate", "Ngày khám phải từ hôm nay trở đi");
            if (!ModelState.IsValid)
            {
                ViewBag.Specialties  = SeedData.GetSpecialties().Where(s => s != "Tất cả").ToList();
                ViewBag.Doctors      = SeedData.GetDoctors();
                ViewBag.Times        = SeedData.GetAppointmentTimes();
                var em = HttpContext.Session.GetString("UserEmail") ?? "";
                ViewBag.Appointments = _db.LayLichHenCuaNguoiDung(em);
                return View(model);
            }
            model.Email = HttpContext.Session.GetString("UserEmail") ?? "";
            int userId  = HttpContext.Session.GetInt32("UserId") ?? 0;
            _db.DatLich(model, userId);
            TempData["Success"] = $"Đặt lịch thành công! Ngay {model.AppointmentDate:dd/MM/yyyy} luc {model.AppointmentTime}.";
            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult GetDoctorsBySpecialty(string specialty)
        {
            var docs = SeedData.GetDoctors()
                .Where(d => d.Specialty == specialty)
                .Select(d => new { d.Id, d.Name });
            return Json(docs);
        }
    }
}
