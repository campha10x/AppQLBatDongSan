﻿using System;
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
        public JsonResult editKhachHang([FromHeader(Name = "IdKhachHang")] string IdKhachHang, [FromHeader(Name = "TenKH")] string TenKH, [FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "NgaySinh")] string NgaySinh, [FromHeader(Name = "GioiTinh")] string GioiTinh, [FromHeader(Name = "SDT")] string SDT, [FromHeader(Name = "Email")] string Email, [FromHeader(Name = "CMND")] string CMND, [FromHeader(Name = "Quequan")] string Quequan, [FromHeader(Name = "NgayCap")] string NgayCap, [FromHeader(Name = "NoiCap")] string NoiCap,  [FromHeader(Name = "Password")] string Password)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.updateKhachHang(IdKhachHang,TenKH, IdCanHo, NgaySinh,GioiTinh,SDT,Email,CMND,Quequan,NgayCap,NoiCap, Password);
            return Json(a);
        }

        [HttpPost("/KhachHang/AddKhachHang")]
        public JsonResult addKhachHang( [FromHeader(Name = "TenKH")] string TenKH, [FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "SDT")] string SDT,  [FromHeader(Name = "CMND")] string CMND,  [FromHeader(Name = "NgayCap")] string NgayCap, [FromHeader(Name = "NoiCap")] string NoiCap)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.addKhachHang(TenKH, IdCanHo,SDT,CMND,NgayCap,NoiCap);
            return Json(a);
        }


        [HttpPost("/KhachHang/EditKhachHang_HopDong")]
        public JsonResult editKhachHang_HopDong([FromHeader(Name = "IdKhachHang")] string IdKhachHang, [FromHeader(Name = "TenKH")] string TenKH, [FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "SDT")] string SDT, [FromHeader(Name = "CMND")] string CMND, [FromHeader(Name = "NgayCap")] string NgayCap, [FromHeader(Name = "NoiCap")] string NoiCap)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            KhachHang a = context.updateKhachHang_HopDong(IdKhachHang, TenKH, IdCanHo, CMND, NgayCap, NoiCap, SDT);
            return Json(a);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
