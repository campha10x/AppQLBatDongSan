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
        public JsonResult EditHopDong([FromBody]HopDong hopdongObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HopDong a = context.updateHopDong(hopdongObject.IdHopDong, hopdongObject.ChuHopDong, hopdongObject.IdCanHo, hopdongObject.SoTienCoc, hopdongObject.NgayBD, hopdongObject.NgayKT, hopdongObject.GhiChu, hopdongObject.IdKhachHang, hopdongObject.TienDien, hopdongObject.TienNuoc, hopdongObject.SoDienBd, hopdongObject.SoNuocBd);
            return Json(a);
        }

        [HttpPost("/HopDong/AddHopDong")]
        public JsonResult AddHopDong([FromBody]HopDong hopdongObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HopDong a = context.addHopDong(hopdongObject.ChuHopDong, hopdongObject.IdCanHo, hopdongObject.SoTienCoc, hopdongObject.NgayBD, hopdongObject.NgayKT, hopdongObject.GhiChu, hopdongObject.IdKhachHang, hopdongObject.TienDien, hopdongObject.TienNuoc, hopdongObject.SoDienBd, hopdongObject.SoNuocBd);
            return Json(a);
        }
    }
}
