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

        [HttpGet("/CanHo/Image/{imgName}")]
        public IActionResult Get(string imgName)
        {
            Byte[] b = System.IO.File.ReadAllBytes(@"../BatDongSanAPI/Image/" + imgName);   // You can use your own method over here.         
            return File(b, "image/jpeg");
        }

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
        public JsonResult EditCanHo([FromHeader(Name = "IdCanHo")] string IdCanHo, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "DienTich")] string DienTich, [FromHeader(Name = "DiaChi")] string DiaChi, [FromHeader(Name = "TieuDe")] string TieuDe, [FromHeader(Name = "MoTa")] string MoTa, [FromHeader(Name = "AnhCanHo")] string AnhCanHo)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo a = context.updateCanHo(IdCanHo, DonGia, DienTich,DiaChi,TieuDe,MoTa,AnhCanHo);
            return Json(a);
        }

        [HttpPost("/CanHo/AddCanHo")]
        public JsonResult AddCanHo([FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "DienTich")] string DienTich, [FromHeader(Name = "DiaChi")] string DiaChi, [FromHeader(Name = "TieuDe")] string TieuDe, [FromHeader(Name = "MoTa")] string MoTa, [FromHeader(Name = "AnhCanHo")] string AnhCanHo, [FromHeader(Name = "NgayTao")] string NgayTao)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo a = context.addCanHo(DonGia,DienTich,DiaChi,TieuDe,MoTa,AnhCanHo,NgayTao);
            return Json(a);
        }

    }
}
