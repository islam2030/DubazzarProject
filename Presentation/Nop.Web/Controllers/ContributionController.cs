using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Nop.Core;
using Nop.Core.Domain.Buckets;
using Nop.Services.Buckets;
using Nop.Services.Catalog;
using Nop.Services.Security;

namespace Nop.Web.Controllers
{
    public class ContributionController : BasePublicController
    {
        private IBucketService _BucketService;
        private IBucketTypeService _BucketTypeService;
        private IBucketItemService _BucketItemService;
        private IProductService _ProductService;
        private IWorkContext _workContext;
        private IPermissionService _permissionService;
        #region Ctor

        public ContributionController(IBucketService BucketService,
           IBucketTypeService productTemplateService,
           IBucketTypeService BucketTypeService,
           IBucketItemService BucketItemService,
          IProductService ProductService,
        //    IUrlRecordService urlRecordService,
           IWorkContext workContext,
        //    ILanguageService languageService,
        //    ILocalizationService localizationService,
        //    ILocalizedEntityService localizedEntityService,
        //    ISpecificationAttributeService specificationAttributeService,
        //    IPictureService pictureService,
        //    ITaxCategoryService taxCategoryService,
        //    IProductTagService productTagService,
        //    ICopyProductService copyProductService,
        //    IPdfService pdfService,
        //    IExportManager exportManager,
        //    IImportManager importManager,
        //    ICustomerActivityService customerActivityService,
           IPermissionService permissionService
        //    IAclService aclService,
        //    IStoreService storeService,
        //    IOrderService orderService,
        //    IStoreMappingService storeMappingService,
        //    IVendorService vendorService,
        //    IDateRangeService dateRangeService,
        //    IShippingService shippingService,
        //    IShipmentService shipmentService,
        //    ICurrencyService currencyService,
        //    CurrencySettings currencySettings,
        //    IMeasureService measureService,
        //    MeasureSettings measureSettings,
        //    IStaticCacheManager cacheManager,
        //    IDateTimeHelper dateTimeHelper,
        //    IDiscountService discountService,
        //    IProductAttributeService productAttributeService,
        //    IBackInStockSubscriptionService backInStockSubscriptionService,
        //    IShoppingCartService shoppingCartService,
        //    IProductAttributeFormatter productAttributeFormatter,
        //    IProductAttributeParser productAttributeParser,
        //    IDownloadService downloadService,
        //    ISettingService settingService,
        //    TaxSettings taxSettings,
        //    VendorSettings vendorSettings
        )

        {
            this._BucketService = BucketService;
            //this._productTemplateService = productTemplateService;
            this._BucketTypeService = BucketTypeService;
            this._BucketItemService = BucketItemService;
            this._ProductService = ProductService;
            //this._urlRecordService = urlRecordService;
            this._workContext = workContext;
            //this._languageService = languageService;
            //this._localizationService = localizationService;
            //this._localizedEntityService = localizedEntityService;
            //this._specificationAttributeService = specificationAttributeService;
            //this._pictureService = pictureService;
            //this._taxCategoryService = taxCategoryService;
            //this._productTagService = productTagService;
            //this._copyProductService = copyProductService;
            //this._pdfService = pdfService;
            //this._exportManager = exportManager;
            //this._importManager = importManager;
            //this._customerActivityService = customerActivityService;
            this._permissionService = permissionService;
            //this._aclService = aclService;
            //this._storeService = storeService;
            //this._orderService = orderService;
            //this._storeMappingService = storeMappingService;
            //this._vendorService = vendorService;
            //this._dateRangeService = dateRangeService;
            //this._shippingService = shippingService;
            //this._shipmentService = shipmentService;
            //this._currencyService = currencyService;
            //this._currencySettings = currencySettings;
            //this._measureService = measureService;
            //this._measureSettings = measureSettings;
            //this._cacheManager = cacheManager;
            //this._dateTimeHelper = dateTimeHelper;
            //this._discountService = discountService;
            //this._productAttributeService = productAttributeService;
            //this._backInStockSubscriptionService = backInStockSubscriptionService;
            //this._shoppingCartService = shoppingCartService;
            //this._productAttributeFormatter = productAttributeFormatter;
            //this._productAttributeParser = productAttributeParser;
            //this._downloadService = downloadService;
            //this._settingService = settingService;
            //this._taxSettings = taxSettings;
            //this._vendorSettings = vendorSettings;
        }

        #endregion
        // GET: Contribution
        public ActionResult Index()
        {
            return View();
        }

        // GET: Contribution/Details/5
        public ActionResult Details(string BucketCode)
        {
            Guid bucketcode = new Guid();
                Guid.TryParse(BucketCode,out bucketcode);
            Bucket bucket = _BucketService.GetBucketByCode(bucketcode);
            return View(bucket);
        }

        // GET: Contribution/Create
        public IActionResult Create(string BucketCode)
        {
            return View();
        }

        // POST: Contribution/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: Contribution/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Contribution/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: Contribution/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Contribution/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}