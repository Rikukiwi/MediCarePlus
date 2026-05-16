using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
using MediCarePlus.Models;
using System.Security.Cryptography;
using System.Text;

namespace MediCarePlus.Controllers
{
    public class AccountController : Controller
    {
        private readonly DatabaseHelper _db;
        public AccountController(DatabaseHelper db) { _db = db; }

        private static string Hash(string input)
            => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(input)));

        [HttpGet]
        public IActionResult Login()
        {
            if (HttpContext.Session.GetString("UserEmail") != null)
                return RedirectToAction("Index", "Home");
            return View();
        }

        [HttpPost, ValidateAntiForgeryToken]
        public IActionResult Login(LoginViewModel model)
        {
            if (!ModelState.IsValid) return View(model);
            var user = _db.DangNhap(model.Email.Trim(), Hash(model.Password));
            if (user == null)
            {
                ModelState.AddModelError("", "Email hoặc mật khẩu không đúng");
                return View(model);
            }
            HttpContext.Session.SetString("UserName",  user.FullName);
            HttpContext.Session.SetString("UserEmail", user.Email);
            HttpContext.Session.SetString("UserRole",  user.Role);
            HttpContext.Session.SetInt32 ("UserId",    user.Id);
            return user.Role == "Admin"
                ? RedirectToAction("Index", "Admin")
                : RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public IActionResult Register()
        {
            if (HttpContext.Session.GetString("UserEmail") != null)
                return RedirectToAction("Index", "Home");
            return View();
        }

        [HttpPost, ValidateAntiForgeryToken]
        public IActionResult Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid) return View(model);
            var (result, message) = _db.DangKy(
                model.FullName.Trim(), model.Email.Trim(),
                model.Phone.Trim(), Hash(model.Password));
            if (result == -1)
            {
                ModelState.AddModelError("Email", message);
                return View(model);
            }
            TempData["Success"] = "Đăng ký thành công! vui lòng đăng nhập";
            return RedirectToAction("Login");
        }

        public IActionResult Logout()
        {
            HttpContext.Session.Remove("UserName");
            HttpContext.Session.Remove("UserEmail");
            HttpContext.Session.Remove("UserRole");
            HttpContext.Session.Remove("UserId");
            return RedirectToAction("Index", "Home");
        }
    }
}
