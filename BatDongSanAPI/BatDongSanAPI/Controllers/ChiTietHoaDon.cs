using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;

namespace BatDongSanAPI.Controllers
{
    public class ChiTietHoaDonController : Controller
    {
        [HttpGet]
        public JsonResult GetListChiTietHoaDon()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<ChiTietHoaDon> listCTHD = context.GetListChiTietHoaDon();
            return Json(listCTHD);
        }

        //[HttpPost("/ChiTietHoaDon/RemoveListChiTietHoaDon")]
        //public JsonResult RemoveListChiTietHoaDon([FromHeader(Name = "IdHoaDon")] string IdHoaDon)
        //{
        //    BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
        //    context.removeHoaDon(IdHoaDon);

        //    string json_string = "{ success: \"'" + IdHoaDon + "'\" }";
        //    return Json(json_string);
        //}


        [HttpPost("/ChiTietHoaDon/AddListChiTietHoaDon")]
        public JsonResult AddListChiTietHoaDon([FromBody] List<ChiTietHoaDon> listChiTietHDObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<ChiTietHoaDon> listCTHD = new List<ChiTietHoaDon>();
            for (int i = 0; i < listChiTietHDObject.Count; i++)
            {
                ChiTietHoaDon a = context.addChiTietHoaDon(listChiTietHDObject[i].Id_HoaDon, listChiTietHDObject[i].TenDichVu, listChiTietHDObject[i].SoCu, listChiTietHDObject[i].SoMoi, listChiTietHDObject[i].DonGia);
                listCTHD.Append(a);
            }
            return Json(listCTHD);
        }

        //[HttpPost("/ChiTietHoaDon/EditListChiTietHoaDon")]
        //public JsonResult EditListChiTietHoaDon([FromBody] ChiTietHoaDon chiTietHDObject)
        //{
        //    BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
        //    HoaDon a = context.updateHoaDon(hoadonObject.IdHoaDon, hoadonObject.IdCanHo, hoadonObject.SoPhieu, hoadonObject.NgayTao, hoadonObject.SoTien, hoadonObject.SoDienMoi, hoadonObject.SoNuocMoi);
        //    return Json(a);
        //}

    }
}
