using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class PhieuChiController : Controller
    {
        [HttpGet("/PhieuChi/GetListPhieuChi")]
        public JsonResult GetListPhieuThu()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<PhieuChi> listPhieuChi = context.GetListPhieuChi();
            return Json(listPhieuChi);
        }

        [HttpPost("/PhieuChi/RemoveListPhieuChi")]
        public JsonResult RemoveListHoaDon([FromHeader(Name = "IdPhieuChi")] string IdPhieuChi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removePhieuChi(IdPhieuChi);
            return Json(IdPhieuChi);
        }

        [HttpPost("/PhieuChi/EditPhieuChi")]
        public JsonResult editPhieuChi([FromBody] PhieuChi phieuChiObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            PhieuChi a = context.updatePhieuChi(phieuChiObject.IdPhieuChi, phieuChiObject.IdCanHo, phieuChiObject.Sotien, phieuChiObject.Ngay, phieuChiObject.DienGiai);
            return Json(a);
        }

        [HttpPost("/PhieuChi/AddPhieuChi")]
        public JsonResult AddPhieuChi([FromBody] PhieuChi phieuChiObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            PhieuChi a = context.addPhieuChi(phieuChiObject.IdCanHo, phieuChiObject.Sotien, phieuChiObject.Ngay, phieuChiObject.DienGiai);
            return Json(a);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
