using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class NhaTroController : Controller
    {
        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet("/NhaTro/GetListNhaTro")]
        public JsonResult GetListNhaTro()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<NhaTro> listNhaTro = context.GetListNhaTro();
            return Json(listNhaTro);
        }
        [HttpPost("/NhaTro/RemoveListNhaTro")]
        public JsonResult RemoveListNhaTro([FromHeader(Name = "idNhaTro")] string idNhaTro)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeNhaTro(idNhaTro);
            return Json(idNhaTro);
        }


        [HttpPost("/NhaTro/EditNhaTro")]
        public JsonResult EditNhaTro([FromHeader(Name = "idNhaTro")] string idNhaTro, [FromHeader(Name = "TenNhaTro")] string TenNhaTro, [FromHeader(Name = "GhiChu")] string GhiChu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            NhaTro a = context.updateNhaTro(idNhaTro, TenNhaTro, GhiChu);
            return Json(a);
        }

        [HttpPost("/NhaTro/AddNhaTro")]
        public JsonResult AddNhaTro([FromHeader(Name = "TenNhaTro")] string TenNhaTro, [FromHeader(Name = "GhiChu")] string GhiChu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            NhaTro a = context.addNhaTro(TenNhaTro, GhiChu);
            return Json(a);
        }
    }
}
