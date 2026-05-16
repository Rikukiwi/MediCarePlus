using Microsoft.AspNetCore.Mvc;
using MediCarePlus.Data;
using MediCarePlus.Models;
namespace MediCarePlus.Controllers
{
    public class DoctorsController : Controller
    {
        public IActionResult Index(string specialty = "Tất cả")
        {
            var all = SeedData.GetDoctors();
            var vm = new DoctorFilterViewModel
            {
                Doctors = specialty == "Tất cả" ? all : all.Where(d => d.Specialty == specialty).ToList(),
                SelectedSpecialty = specialty,
                Specialties = SeedData.GetSpecialties()
            };
            return View(vm);
        }
        public IActionResult Detail(int id)
        {
            var doc = SeedData.GetDoctors().FirstOrDefault(d => d.Id == id);
            if (doc == null) return NotFound();
            return View(doc);
        }
    }
}
