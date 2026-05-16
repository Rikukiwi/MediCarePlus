using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
using MediCarePlus.Models;

namespace MediCarePlus.Controllers
{
    public class ContactController : Controller
    {
        private readonly DatabaseHelper _db;
        public ContactController(DatabaseHelper db) { _db = db; }

        [HttpGet]
        public IActionResult Index() => View(new ContactMessage());

        [HttpPost, ValidateAntiForgeryToken]
        public IActionResult Index(ContactMessage model)
        {
            if (!ModelState.IsValid) return View(model);
            _db.LuuTinNhan(model.Name, model.Phone, model.Subject, model.Message);
            TempData["Success"] = "Cảm ơn bạn đã liên hệ! Chúng tối sẽ phản hồi trong vòng 24h.";
            return RedirectToAction("Index");
        }
    }
}
