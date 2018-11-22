using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class PhongController : Controller
    {
        [HttpGet("/Phong/GetListPhong")]
        // GET: /<controller>/
        public JsonResult GetListPhong()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<Phong> listPhong = context.GetListPhong();
            return Json(listPhong);
        }

        [HttpPost("/Phong/RemoveListPhong")]
        public JsonResult RemoveListPhong([FromHeader(Name = "idPhong")] string idPhong)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removePhong(idPhong);
            return Json(idPhong);
        }


        [HttpPost("/Phong/EditPhong")]
        public JsonResult EditPhong([FromHeader(Name = "idPhong")] string idPhong, [FromHeader(Name = "TenPhong")] string TenPhong, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "SoDien")] string SoDien, [FromHeader(Name = "SoNuoc")] string SoNuoc, [FromHeader(Name = "IdNhaTro")] string IdNhaTro)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Phong a = context.updatePhong(idPhong,TenPhong, DonGia, SoDien, SoNuoc, IdNhaTro);
            return Json(a);
        }

        [HttpPost("/Phong/AddPhong")]
        public JsonResult AddPhong( [FromHeader(Name = "TenPhong")] string TenPhong, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "SoDien")] string SoDien, [FromHeader(Name = "SoNuoc")] string SoNuoc, [FromHeader(Name = "IdNhaTro")] string IdNhaTro)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            Phong a = context.addPhong(TenPhong, DonGia, SoDien, SoNuoc, IdNhaTro);
            return Json(a);
        }

    }
}
