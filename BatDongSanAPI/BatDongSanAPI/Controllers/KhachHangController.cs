using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class KhachHangController : Controller
    {
        [HttpGet("/KhachHang/GetListKhachHang")]
        public JsonResult GetListHoaDon()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<KhachHang> listKhachHang = context.GetListKhachHang();
            return Json(listKhachHang);
        }


        [HttpGet("/KhachHang/Index/{email}/{password}")]
        public IActionResult Index(string email, string password)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.GetInformationKhachHang(email, password).First();
            return Json(a);
        }

        [HttpPost("/KhachHang/RemoveListKhachHang")]
        public JsonResult RemoveListHoaDon([FromHeader(Name = "IdKhachHang")] string IdKhachHang)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeKhachHang(IdKhachHang);
            return Json(IdKhachHang);
        }

        [HttpPost("/KhachHang/EditKhachHang")]
        public JsonResult editKhachHang([FromBody] KhachHang khachhangObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.updateKhachHang(khachhangObject.IdKhachHang, khachhangObject.TenKH, khachhangObject.IdCanHo, khachhangObject.NgaySinh, khachhangObject.GioiTinh, khachhangObject.SDT, khachhangObject.Email, khachhangObject.CMND, khachhangObject.Quequan, khachhangObject.NgayCap, khachhangObject.NoiCap, khachhangObject.Password);
            return Json(a);
        }

        [HttpPost("/KhachHang/AddKhachHang")]
        public JsonResult addKhachHang([FromBody] KhachHang khachhangObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.addKhachHang(khachhangObject.TenKH, khachhangObject.IdCanHo, khachhangObject.SDT, khachhangObject.CMND, khachhangObject.NgayCap, khachhangObject.NoiCap);
            return Json(a);
        }


        [HttpPost("/KhachHang/EditKhachHang_HopDong")]
        public JsonResult editKhachHang_HopDong([FromBody] KhachHang khachhangObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.updateKhachHang_HopDong(khachhangObject.IdKhachHang, khachhangObject.TenKH, khachhangObject.IdCanHo, khachhangObject.CMND, khachhangObject.NgayCap, khachhangObject.NoiCap, khachhangObject.SDT);
            return Json(a);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
