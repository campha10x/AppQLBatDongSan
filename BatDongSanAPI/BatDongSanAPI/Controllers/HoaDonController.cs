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

        [HttpGet("/HoaDon/GetListHoaDon_Phong")]
        public JsonResult GetListHoaDon_Phong()
        {
            string host = Dns.GetHostName();
            IPHostEntry ip = Dns.GetHostEntry(host);

            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<HoaDon_Phong> listHoaDon = context.getListHoaDon_Phong();
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
        public JsonResult AddListHoaDon([FromHeader(Name = "IdPhong")] string IdPhong, [FromHeader(Name = "SoPhieu")] string SoPhieu, [FromHeader(Name = "NgayTao")] string NgayTao, [FromHeader(Name = "SoTien")] string SoTien)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.AddListHoaDon(IdPhong, SoPhieu, NgayTao, SoTien);
            return Json(a);
        }

        [HttpPost("/HoaDon/EditListHoaDon")]
        public JsonResult EditListHoaDon([FromHeader(Name = "IdHoaDon")] string IdHoaDon, [FromHeader(Name = "IdPhong")] string IdPhong, [FromHeader(Name = "SoPhieu")] string SoPhieu, [FromHeader(Name = "NgayTao")] string NgayTao, [FromHeader(Name = "SoTien")] string SoTien)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HoaDon a = context.updateHoaDon(IdHoaDon, IdPhong, SoPhieu, NgayTao, SoTien);
            return Json(a);
        }
    }
}
