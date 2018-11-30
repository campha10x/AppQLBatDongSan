using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class CanHoController : Controller
    {
        [HttpGet("/CanHo/GetListCanHo")]
        // GET: /<controller>/
        public JsonResult GetListCanHo()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<CanHo> listCanHo = context.GetListCanHo();
            return Json(listCanHo);
        }

        [HttpPost("/CanHo/RemoveListCanHo")]
        public JsonResult RemoveListCanHo([FromHeader(Name = "IdCanHo")] string IdCanHo)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeCanHo(IdCanHo);
            return Json(IdCanHo);
        }


        [HttpPost("/CanHo/EditCanHo")]
        public JsonResult EditCanHo([FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "TenCanHo")] string TenCanHo, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "SoDienCu")] string SoDienCu, [FromHeader(Name = "SoNuocCu")] string SoNuocCu, [FromHeader(Name = "DienTich")] string DienTich, [FromHeader(Name = "DiaChi")] string DiaChi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo a = context.updateCanHo(IdCanHo,TenCanHo,DonGia,SoDienCu,SoNuocCu,DienTich,DiaChi);
            return Json(a);
        }

        [HttpPost("/CanHo/AddCanHo")]
        public JsonResult AddCanHo([FromHeader(Name = "TenCanHo")] string TenCanHo, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "SoDienCu")] string SoDienCu, [FromHeader(Name = "SoNuocCu")] string SoNuocCu, [FromHeader(Name = "DienTich")] string DienTich, [FromHeader(Name = "DiaChi")] string DiaChi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo a = context.addCanHo(TenCanHo,DonGia,SoDienCu,SoNuocCu,DienTich, DiaChi);
            return Json(a);
        }

    }
}
