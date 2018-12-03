using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class DichVuController : Controller
    {

        [HttpGet]
        public JsonResult GetListDichVu()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<DichVu> listDichVu = context.GetListDichVu();
            return Json(listDichVu);
        }

        [HttpPost("/DichVu/RemoveListDichVu")]
        public JsonResult RemoveListDichVu([FromHeader(Name = "idDichVu")] string idDichVu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeDichVu(idDichVu);
            return Json(idDichVu);
        }


        [HttpPost("/DichVu/EditDichVu")]
        public JsonResult EditDichVu([FromHeader(Name = "idDichVu")] string idDichVu, [FromHeader(Name = "TenDichVu")] string TenDichVu, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "Donvi")] string donvi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DichVu a = context.updateDichVu(idDichVu, TenDichVu, DonGia, donvi);
            return Json(a);
        }

        [HttpPost("/DichVu/AddDichVu")]
        public JsonResult AddDichVu([FromHeader(Name = "TenDichVu")] string TenDichVu, [FromHeader(Name = "DonGia")] string DonGia, [FromHeader(Name = "Donvi")] string donvi)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DichVu a = context.addDichvu(TenDichVu, DonGia, donvi);
            return Json(a);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
