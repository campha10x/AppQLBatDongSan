using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
using System.Net.Sockets;
using System.Net;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class HoaDonController : Controller
    {
        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet("/HoaDon/GetListHoaDon")]
        public JsonResult GetListHoaDon()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<HoaDon> listHoaDon = context.GetListHoaDon();
            return Json(listHoaDon);
        }

        [HttpPost("/HoaDon/RemoveListHoaDon")]
        public JsonResult RemoveListHoaDon([FromHeader(Name = "IdHoaDon")] string IdHoaDon)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeHoaDon(IdHoaDon);
           
            string json_string = "{ success: \"'" + IdHoaDon + "'\" }";
            return Json(json_string); 
        }


        [HttpPost("/HoaDon/AddListHoaDon")]
        public JsonResult AddListHoaDon([FromBody] HoaDon hoadonObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.AddListHoaDon(hoadonObject.IdCanHo, hoadonObject.SoPhieu, hoadonObject.NgayTao, hoadonObject.SoTien, hoadonObject.SoDienMoi, hoadonObject.SoNuocMoi);
            return Json(a);
        }

        [HttpPost("/HoaDon/EditListHoaDon")]
        public JsonResult EditListHoaDon([FromBody] HoaDon hoadonObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.updateHoaDon(hoadonObject.IdHoaDon, hoadonObject.IdCanHo, hoadonObject.SoPhieu, hoadonObject.NgayTao, hoadonObject.SoTien, hoadonObject.SoDienMoi, hoadonObject.SoNuocMoi);
            return Json(a);
        }


        [HttpPost("/HoaDon/UpdateHoaDon_PhieuThu")]
        public JsonResult UpdateHoaDon_PhieuThu([FromHeader(Name = "IdHoaDon")] string IdHoaDon, [FromHeader(Name = "IdPhieuThu")] string IdPhieuThu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            String a = context.UpdateHoaDon_PhieuThu(IdHoaDon,IdPhieuThu);
            return Json(a);
        }

    }
}
