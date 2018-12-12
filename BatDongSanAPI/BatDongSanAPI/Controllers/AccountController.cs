using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{

    public class AccountController : Controller
    {
        // GET: /<controller>/
        [HttpGet("/Account/Index/{email}/{password}")]
        public IActionResult Index(string email, string password)
        {


            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Account a = context.GetInformationAccount(email, password).First();
            return Json(a);
        }

        [HttpPost("/Account/EditAccount")]
        public JsonResult EditAccount([FromHeader(Name = "IdAccount")] string IdAccount, [FromHeader(Name = "HoTen")] string HoTen, [FromHeader(Name = "GioiTinh")] string GioiTinh, [FromHeader(Name = "NamSinh")] string NamSinh, [FromHeader(Name = "SDT")] string SDT, [FromHeader(Name = "DiaChi")] string DiaChi, [FromHeader(Name = "CMND")] string CMND, [FromHeader(Name = "NgayCap")] string NgayCap, [FromHeader(Name = "NoiCap")] string NoiCap)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Account a = context.updateAccount(IdAccount,HoTen, GioiTinh, NamSinh, SDT, DiaChi,CMND,NgayCap,NoiCap);
            return Json(a);
        }

        [HttpPost("/Account/AddAccount")]
        public JsonResult RegisterAccount([FromHeader(Name = "Email")] string Email, [FromHeader(Name = "MatKhau")] string MatKhau, [FromHeader(Name = "SDT")] string SDT)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Account a = context.AddAccount(Email, MatKhau, SDT);
            return Json(a);
        }

        public IActionResult Index()
        {
            return View();
        }
    }
}
