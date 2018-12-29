using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class PhieuThuController : Controller
    {
        [HttpPost("/PhieuThu/AddPhieuThu")]
        public JsonResult addPhieuThu([FromBody] PhieuThu phieuThuObject) {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            PhieuThu a = context.addPhieuThu(phieuThuObject.IdCanHo, phieuThuObject.IdHoaDon, phieuThuObject.Sotien, phieuThuObject.Ngay, phieuThuObject.GhiChu);
            return Json(a);
        }

        [HttpGet("/PhieuThu/GetListPhieuThu")]
        public JsonResult GetListPhieuThu()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<PhieuThu> listPhieuThu = context.GetListPhieuThu();
            return Json(listPhieuThu);
        }

        [HttpPost("/PhieuThu/RemoveListPhieuThu")]
        public JsonResult RemoveListHoaDon([FromHeader(Name = "IdPhieuThu")] string IdPhieuThu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removePhieuThu(IdPhieuThu);
            return Json(IdPhieuThu);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
