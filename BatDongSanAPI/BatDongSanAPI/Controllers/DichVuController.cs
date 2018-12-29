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
        public JsonResult RemoveListDichVu([FromHeader(Name = "IdDichVu")] string IdDichVu)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeDichVu(IdDichVu);
            return Json(IdDichVu);
        }


        [HttpPost("/DichVu/EditDichVu")]
        public JsonResult EditDichVu([FromBody]DichVu dichvuObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DichVu a = context.updateDichVu(dichvuObject.IdDichVu, dichvuObject.TenDichVu, dichvuObject.DonVi);
            return Json(a);
        }

        [HttpPost("/DichVu/AddDichVu")]
        public JsonResult AddDichVu([FromBody]DichVu dichvuObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            DichVu a = context.addDichvu(dichvuObject.TenDichVu, dichvuObject.DonVi);
            return Json(a);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
