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

        [HttpGet("/HoaDon/GetListHoaDon_CanHo")]
        public JsonResult GetListHoaDon_CanHo()
        {
            string host = Dns.GetHostName();
            IPHostEntry ip = Dns.GetHostEntry(host);

            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<HoaDon_CanHo> listHoaDon = context.getListHoaDon_CanHo();
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
        public JsonResult AddListHoaDon([FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "SoPhieu")] string SoPhieu, [FromHeader(Name = "NgayTao")] string NgayTao, [FromHeader(Name = "SoTien")] string SoTien)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.AddListHoaDon(IdCanHo, SoPhieu, NgayTao, SoTien);
            return Json(a);
        }

        [HttpPost("/HoaDon/EditListHoaDon")]
        public JsonResult EditListHoaDon([FromHeader(Name = "IdHoaDon")] string IdHoaDon, [FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "SoPhieu")] string SoPhieu, [FromHeader(Name = "NgayTao")] string NgayTao, [FromHeader(Name = "SoTien")] string SoTien)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.updateHoaDon(IdHoaDon, IdCanHo, SoPhieu, NgayTao, SoTien);
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
