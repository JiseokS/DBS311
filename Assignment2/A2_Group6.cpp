/*--***********************
  --Student1 Name : Jiseok Shim Student1 ID : 122758170
  --Date : 2022 - 08 - 09
  --Purpose: Assignment 2 - DBS311
  --***********************
*/
#include <iostream>
#include <iomanip>
#include <string>
#include <cctype>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;


struct ShoppingCart {
    int product_id;
    double price;
    int quantity;
};

// Fuction Prototypes
int mainMenu();
double findProduct(Connection* conn, int product_id);
int customerLogin(Connection* conn, int customerId);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);

int main() {
    // Declare the environment and the connection variables
    Environment* env = nullptr;
    Connection* conn = nullptr;

    // Define and initialize the variable to store the username, password, and the host address
    string user = "dbs311_222b22";
    string pass = "11492198";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

    try {
        // Create the environment and the connection
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is successful!" << endl;


        bool flag = true;
        int select = 0, customerID = 0, found = 0, productCount = 0;
        ShoppingCart cart[5];
        do {
            select = mainMenu();
            switch (select) {
            case 1:
                cout << "Enter the customer ID: ";
                cin >> customerID;
                found = customerLogin(conn, customerID);
                if (found == 0) {
                    cout << "The customer does not exist." << endl;
                }
                else {
                    productCount = addToCart(conn, cart);
                    displayProducts(cart, productCount);
                    checkout(conn, cart, customerID, productCount);
                }
                break;
            case 0:
                cout << "Good bye!..." << endl;
                flag = false;
                break;
            }
        } while (flag);
        // Terminate and close the connection and the environment, when the program terminates
        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    // Handle any errors may be thrown as the program is executed
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }

    return 0;
}

int mainMenu() {
    int select = 0;
    cout << "******************** Main Menu ********************\n";
    cout << "1) Login" << endl;
    cout << "0) Exit\n" << endl;
    cout << "Enter an option (0-1): ";
    cin >> select;
    while (select < 0 || select > 1) {
        cout << "******************** Main Menu ********************\n";
        cout << "1) Login" << endl;
        cout << "0) Exit\n" << endl;
        cout << "You entered a wrong value. Enter an option (0-1):";
        cin >> select;
    }
    return select;
}

double findProduct(Connection* conn, int product_id) {
    double price;
    // Statement object to execute SQL scripts
    Statement* stmt = conn->createStatement();
    // Specify input parameters
    stmt->setSQL("BEGIN find_product(:1, :2); END;");
    // specify the first IN parameter 
    stmt->setInt(1, product_id);
    // specify type and size of the second OUT parameter
    stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));
    // Call procedure
    stmt->executeUpdate();
    price = stmt->getDouble(2);
    // Terminate statement
    conn->terminateStatement(stmt);
    return price > 0 ? price : 0; // price = 0 if id is not valid
}

int customerLogin(Connection* conn, int customerId) {
    int search_id;

    Statement* stmt = conn->createStatement();
    stmt->setSQL("BEGIN find_customer(:1, :2); END;");
    stmt->setInt(1, customerId);
    stmt->registerOutParam(2, Type::OCCIINT, sizeof(search_id));
    stmt->executeUpdate();
    search_id = stmt->getInt(2);
    conn->terminateStatement(stmt);

    return search_id;
}

int addToCart(Connection* conn, struct ShoppingCart cart[]) {
    int count = 0, checkout = 1, productId = 0, quantity = 0;
    bool flag = true;
    double price = 0.00;
    cout << "-------------- Add Products to Cart --------------" << endl;
    while (flag == true) {
        cout << "Enter the product ID: ";
        cin >> productId;
        price = findProduct(conn, productId);
        if (price == 0) {
            cout << "The product does not exists. Try again..." << endl;
        }
        else {
            cout << "Product Price: " << price << endl;
            cout << "Enter the product Quantity: ";
            cin >> quantity;
            cart[count].product_id = productId;
            cart[count].price = price;
            cart[count].quantity = quantity;
            cout << "Enter 1 to add more products or 0 to checkout: ";
            cin >> checkout;
            switch (checkout) {
            case 1:
                count++;
                break;
            case 0:
                count++;
                displayProducts(cart, count);
                flag = false;
                break;
            default:
                break;
            }
        }
    }
    return count;
}

void displayProducts(struct ShoppingCart cart[], int productCount) {
    double totalPrice = 0.0;
    if (productCount > 0) {
        cout << "------- Ordered Products ---------" << endl;
        for (int i = 0; i < productCount; ++i) {
            cout << "---Item " << i + 1 << endl;
            cout << "Product ID: " << cart[i].product_id << endl;
            cout << "Price: " << cart[i].price << endl;
            cout << "Quantity: " << cart[i].quantity << endl;
            totalPrice += cart[i].price * cart[i].quantity;
        }
        cout << "----------------------------------\nTotal: " << totalPrice << endl;
    }
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
    char choice;
    do {
        cout << "Would you like to checkout ? (Y / y or N / n) ";
        cin >> choice;
        if (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n')
            cout << "Wrong input. Try again..." << endl;
    } while (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n');
    if (choice == 'N' || choice == 'n') {
        cout << "The order is cancelled." << endl;
        return 0;
    }
    else {
        // Statement object to execute SQL scripts
        Statement* stmt = conn->createStatement();
        // Specify input parameters
        stmt->setSQL("BEGIN add_order(:1, :2); END;");
        int next_order_id;
        // specify the first IN parameter
        stmt->setInt(1, customerId);
        // specify type and size of the second OUT parameter
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(next_order_id));
        // Call procedure
        stmt->executeUpdate();
        next_order_id = stmt->getInt(2);

        for (int i = 0; i < productCount; ++i) {
            // Reset Statement object
            stmt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");
            // Set IN parameters
            stmt->setInt(1, next_order_id);
            stmt->setInt(2, i + 1);
            stmt->setInt(3, cart[i].product_id);
            stmt->setInt(4, cart[i].quantity);
            stmt->setDouble(5, cart[i].price);
            // Call procedure
            stmt->executeUpdate();
        }
        cout << "The order is successfully completed." << endl;
        // Terminate statement
        conn->terminateStatement(stmt);
        return 1;
    }
}