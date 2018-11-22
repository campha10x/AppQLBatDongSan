using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class DonViController : Controller
    {
        [HttpGet("/DonVi/GetListDonVi")]
        public JsonResult GetListDonVi()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<DonVi> listDonVi = context.GetListDonVi();
            return Json(listDonVi);
        }

        [HttpPost("/DonVi/RemoveListDonVi")]
        public JsonResult RemoveListDonVi([FromHeader(Name = "idDonVi")] string idDonVi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeDonVi(idDonVi);
            return Json(idDonVi);
        }


        [HttpPost("/DonVi/EditDonVi")]
        public JsonResult EditDonVi([FromHeader(Name = "idDonVi")] string idDonVi, [FromHeader(Name = "TenDonVi")] string TenDonVi, [FromHeader(Name = "GhiChu")] string GhiChu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DonVi a = context.updateDonVi(idDonVi, TenDonVi, GhiChu);
            return Json(a);
        }

        [HttpPost("/DonVi/AddDonVi")]
        public JsonResult AddDonVi([FromHeader(Name = "TenDonVi")] string TenDonVi, [FromHeader(Name = "GhiChu")] string GhiChu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DonVi a = context.addDonVi(TenDonVi, GhiChu);
            return Json(a);
        }
        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
