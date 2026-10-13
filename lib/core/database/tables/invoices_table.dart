import 'package:drift/drift.dart';

import 'products_table.dart';
import 'quotations_table.dart';

/// Drift table definition for sales invoice headers.
@TableIndex(name: 'idx_invoices_ref', columns: {#referenceNumber}, unique: true)
@TableIndex(name: 'idx_invoices_customer', columns: {#customerName})
@TableIndex(name: 'idx_invoices_status', columns: {#status})
@DataClassName('InvoiceEntry', companion: 'InvoiceCompanion')
class InvoicesTable extends Table {
  @override
  String get tableName => 'invoices';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get referenceNumber =>
      text().customConstraint('NOT NULL UNIQUE')();

  IntColumn get quotationId => integer().nullable().references(
    QuotationsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get customerName => text()();

  TextColumn get customerPhone => text().nullable()();

  TextColumn get status => text().withDefault(const Constant('unpaid'))();

  IntColumn get issueDate => integer()();

  IntColumn get dueDate => integer().nullable()();

  TextColumn get notes => text().nullable()();

  IntColumn get subtotalPiastres => integer().withDefault(const Constant(0))();

  IntColumn get discountPiastres => integer().withDefault(const Constant(0))();

  IntColumn get taxPiastres => integer().withDefault(const Constant(0))();

  IntColumn get grandTotalPiastres =>
      integer().withDefault(const Constant(0))();

  IntColumn get paidAmountPiastres =>
      integer().withDefault(const Constant(0))();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();
}

/// Drift table definition for sales invoice item snapshots.
@TableIndex(name: 'idx_invoice_items_invoice', columns: {#invoiceId})
@DataClassName('InvoiceItemEntry', companion: 'InvoiceItemCompanion')
class InvoiceItemsTable extends Table {
  @override
  String get tableName => 'invoice_items';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get invoiceId =>
      integer().references(InvoicesTable, #id, onDelete: KeyAction.cascade)();

  IntColumn get productId => integer().nullable().references(
    ProductsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get productCode => text()();

  TextColumn get productName => text()();

  TextColumn get unit => text()();

  IntColumn get unitPricePiastres => integer()();

  IntColumn get quantity => integer()();

  IntColumn get lineDiscountPiastres =>
      integer().withDefault(const Constant(0))();

  IntColumn get lineTotalPiastres => integer()();
}

/// Drift table definition for invoice payment transactions.
@TableIndex(name: 'idx_invoice_payments_invoice', columns: {#invoiceId})
@DataClassName('InvoicePaymentEntry', companion: 'InvoicePaymentCompanion')
class InvoicePaymentsTable extends Table {
  @override
  String get tableName => 'invoice_payments';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get invoiceId =>
      integer().references(InvoicesTable, #id, onDelete: KeyAction.cascade)();

  IntColumn get amountPiastres => integer()();

  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();

  IntColumn get paymentDate => integer()();

  TextColumn get notes => text().nullable()();

  IntColumn get createdAt => integer()();
}
