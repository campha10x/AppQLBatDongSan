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
        public JsonResult addPhieuThu([FromHeader(Name = "IdPhong")] string IdPhong, [FromHeader(Name = "IdHoaDon")] string IdHoaDon, [FromHeader(Name = "SoTien")] string SoTien, [FromHeader(Name = "Ngay")] string Ngay, [FromHeader(Name = "GhiChu")] string GhiChu) {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            PhieuThu a = context.addPhieuThu(IdPhong,IdHoaDon,SoTien,Ngay,GhiChu);
            return Json(a);
        }

        [HttpGet("/HoaDon/GetListPhieuThu")]
        public JsonResult GetListPhieuThu()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<PhieuThu> listPhieuThu = context.GetListPhieuThu();
            return Json(listPhieuThu);
        }

        [HttpPost(" /PhieuThu/RemoveListPhieuThu")]
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
