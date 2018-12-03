using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class HopDongController : Controller
    {
        [HttpGet("/HopDong/GetListHopDong")]
        public JsonResult GetListHopDong()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<HopDong> listHopDong = context.GetListHopDong();
            return Json(listHopDong);
        }

        [HttpPost("/HopDong/RemoveListHopDong")]
        public JsonResult RemoveListHopDong([FromHeader(Name = "IdHopDong")] string IdHopDong)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeHopDong(IdHopDong);
            return Json(IdHopDong);
        }


        [HttpPost("/HopDong/EditHopDong")]
        public JsonResult EditHopDong([FromHeader(Name = "IdHopDong")] string IdHopDong, [FromHeader(Name = "ChuHopDong")] string ChuHopDong, [FromHeader(Name = "idCanHo")] string idCanHo, [FromHeader(Name = "SoTienCoc")] string SoTienCoc, [FromHeader(Name = "NgayBD")] string NgayBD, [FromHeader(Name = "NgayKT")] string NgayKT, [FromHeader(Name = "GhiChu")] string GhiChu, [FromHeader(Name = "IdKhachHang")] string IdKhachHang)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HopDong a = context.updateHopDong(IdHopDong, ChuHopDong, idCanHo, SoTienCoc, NgayBD, NgayKT, GhiChu, IdKhachHang);
            return Json(a);
        }

        [HttpPost("/HopDong/AddHopDong")]
        public JsonResult AddHopDong([FromHeader(Name = "ChuHopDong")] string ChuHopDong, [FromHeader(Name = "idCanHo")] string idCanHo, [FromHeader(Name = "SoTienCoc")] string SoTienCoc, [FromHeader(Name = "NgayBD")] string NgayBD, [FromHeader(Name = "NgayKT")] string NgayKT, [FromHeader(Name = "GhiChu")] string GhiChu, [FromHeader(Name = "IdKhachHang")] string IdKhachHang)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HopDong a = context.addHopDong(ChuHopDong, idCanHo, SoTienCoc, NgayBD, NgayKT, GhiChu, IdKhachHang);
            return Json(a);
        }
    }
}
