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

        [HttpGet("/Account/GetListAccounts")]
        public JsonResult GetListAccounts()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<Account> listHopDong = context.GetListAccounts();
            return Json(listHopDong);
        }

        // GET: /<controller>/
        [HttpPost("/Account/Index")]
        public IActionResult Index([FromBody]Account accountObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Account a = context.GetInformationAccount(accountObject.Email, accountObject.MatKhau).First();
            return Json(a);
        }

        [HttpPost("/Account/EditAccount")]
        public JsonResult EditAccount([FromBody] Account accountObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Account a = context.updateAccount(accountObject.IdAccount, accountObject.HoTen, accountObject.Gioitinh, accountObject.NamSinh, accountObject.SDT, accountObject.DiaChi, accountObject.CMND, accountObject.NgayCap, accountObject.NoiCap);
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
