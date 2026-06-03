using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
namespace MediCarePlus.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            ViewBag.Doctors  = SeedData.GetDoctors().Take(3).ToList();
            ViewBag.Services = SeedData.GetServices();
            return View();
        }
        public IActionResult About() => View();
        public IActionResult Error() => View();
    }
}
