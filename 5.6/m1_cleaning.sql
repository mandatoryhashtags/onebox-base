SET @prefix = '';

-- Clear the base_url
SET @sql = CONCAT('UPDATE 
    `', @prefix, 'core_config_data` SET value = ''{{base_url}}'' 
WHERE
    `path` = ''web/unsecure/base_url''
    OR `path` = ''web/secure/base_url''
    OR `path` = ''admin/url/custom''
    OR `path` = ''web/unsecure/base_link_url''
    OR `path` = ''web/secure/base_link_url''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Clear the JS
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET `value` = ''{{base_url}}/js/''
WHERE
   `path` = ''web/unsecure/base_js_url''
   OR `path` = ''web/secure/base_js_url''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Clear the media path
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET value = ''{{base_url}}/media/''
WHERE
    `path` = ''web/unsecure/base_media_url''
    OR `path` = ''web/secure/base_media_url''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Clear the skin path
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET value = ''{{base_url}}/skin/''
WHERE
   `path` = ''web/unsecure/base_skin_url''
   OR `path` = ''web/secure/base_skin_url''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Clear the cookie domain
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET value = ''''
WHERE 
    `path` = ''web/cookie/cookie_domain''
    OR `path` = ''web/cookie/cookie_path''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Disable SSL for frontend and backend
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET `value` = ''0''
WHERE
    `path` = ''web/secure/use_in_frontend''
    OR `path` = ''web/secure/use_in_frontend''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Clear log tables
SET @query = CONCAT('DELETE FROM `', @prefix, 'log_url`;
DELETE FROM `', @prefix, 'log_url_info`;
DELETE FROM `', @prefix, 'log_visitor`;
DELETE FROM `', @prefix, 'log_visitor_info`;''');

PREPARE query FROM @sql;
EXECUTE query;
 
-- Disable caching
SET @sql = CONCAT('UPDATE `', @prefix, 'core_cache_option`
    SET `value` = ''0''');

PREPARE query FROM @sql;
EXECUTE query;
    
-- Remove custom admin paths
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET `value` = 0
WHERE
    `path` = ''admin/url/use_custom_path''');

PREPARE query FROM @sql;
EXECUTE query;
    
-- Clear sales email addresses
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
    SET `value` = NULL
WHERE
    `path` IN ( ''trans_email/ident_general/email'',
                ''trans_email/ident_sales/email'',
                ''trans_email/ident_support/email'',
                ''trans_email/ident_custom1/email'',
                ''trans_email/ident_custom2/email'',
                ''sales_email/order/copy_to'',
                ''sales_email/order_comment/copy_to'',
                ''vsales_email/invoice/copy_to'',
                ''sales_email/invoice_comment/copy_to'',
                ''sales_email/shipment/copy_to'',
                ''sales_email/shipment_comment/copy_to'',
                ''vsales_email/creditmemo/copy_to'',
                ''vsales_email/creditmemo_comment/copy_to'')');
PREPARE query FROM @sql;
EXECUTE query;
                
-- Enable check/money order on site
SET @sql = CONCAT('UPDATE `', @prefix, 'core_config_data`
	SET `value` = 1
WHERE `path` = ''payment/checkmo/active''');

PREPARE query FROM @sql;
EXECUTE query;