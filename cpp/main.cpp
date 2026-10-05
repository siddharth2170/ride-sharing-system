#include <iomanip>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

class Ride {
private:
    std::string rideID_;
    std::string pickupLocation_;
    std::string dropoffLocation_;
    double distanceMiles_;

protected:
    double baseFare(double ratePerMile, double bookingFee) const {
        return bookingFee + distanceMiles_ * ratePerMile;
    }

public:
    Ride(std::string rideID, std::string pickup, std::string dropoff,
         double distanceMiles)
        : rideID_(std::move(rideID)), pickupLocation_(std::move(pickup)),
          dropoffLocation_(std::move(dropoff)), distanceMiles_(distanceMiles) {
        if (distanceMiles < 0.0) {
            throw std::invalid_argument("Distance cannot be negative");
        }
    }

    virtual ~Ride() = default;
    virtual double fare() const = 0;
    virtual std::string rideType() const = 0;

    const std::string& rideID() const { return rideID_; }
    double distanceMiles() const { return distanceMiles_; }

    virtual void rideDetails(std::ostream& out) const {
        out << rideType() << " ride " << rideID_ << ": "
            << pickupLocation_ << " -> " << dropoffLocation_ << ", "
            << std::fixed << std::setprecision(1) << distanceMiles_
            << " miles, fare $" << std::setprecision(2) << fare();
    }
};

class StandardRide final : public Ride {
public:
    using Ride::Ride;
    double fare() const override { return baseFare(2.00, 3.00); }
    std::string rideType() const override { return "Standard"; }
};

class PremiumRide final : public Ride {
public:
    using Ride::Ride;
    double fare() const override { return baseFare(3.50, 7.50); }
    std::string rideType() const override { return "Premium"; }
};

class Driver {
private:
    std::string driverID_;
    std::string name_;
    double rating_;
    std::vector<std::shared_ptr<Ride>> assignedRides_;

public:
    Driver(std::string driverID, std::string name, double rating)
        : driverID_(std::move(driverID)), name_(std::move(name)), rating_(rating) {
        if (rating < 0.0 || rating > 5.0) {
            throw std::invalid_argument("Rating must be between 0 and 5");
        }
    }

    void addRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        assignedRides_.push_back(ride);
    }

    void getDriverInfo(std::ostream& out) const {
        out << "Driver " << name_ << " (" << driverID_ << "), rating "
            << std::fixed << std::setprecision(1) << rating_ << "/5, completed "
            << assignedRides_.size() << " rides\n";
    }

    std::size_t completedRideCount() const { return assignedRides_.size(); }
};

class Rider {
private:
    std::string riderID_;
    std::string name_;
    std::vector<std::shared_ptr<Ride>> requestedRides_;

public:
    Rider(std::string riderID, std::string name)
        : riderID_(std::move(riderID)), name_(std::move(name)) {}

    void requestRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        requestedRides_.push_back(ride);
    }

    void viewRides(std::ostream& out) const {
        out << "Ride history for " << name_ << " (" << riderID_ << "):\n";
        for (const auto& ride : requestedRides_) {
            out << "  - ";
            ride->rideDetails(out);
            out << '\n';
        }
    }
};

int main() {
    std::vector<std::shared_ptr<Ride>> rides{
        std::make_shared<StandardRide>("R-101", "Campus", "Airport", 12.5),
        std::make_shared<PremiumRide>("R-102", "Downtown", "Museum", 6.0),
        std::make_shared<StandardRide>("R-103", "Library", "Station", 4.25)
    };

    Driver driver("D-17", "Maya Chen", 4.9);
    Rider rider("U-42", "Jordan Lee");
    for (const auto& ride : rides) {
        driver.addRide(ride);
        rider.requestRide(ride);
    }

    std::cout << "=== Ride Sharing System: C++ ===\n";
    driver.getDriverInfo(std::cout);
    rider.viewRides(std::cout);
    std::cout << "\nPolymorphic fare calculation:\n";
    for (const auto& ride : rides) {
        std::cout << "  " << ride->rideType() << " " << ride->rideID()
                  << " = $" << std::fixed << std::setprecision(2)
                  << ride->fare() << '\n';
    }
}
